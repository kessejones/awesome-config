use mlua::prelude::*;

use alsa::mixer::{SelemChannelId, SelemId};

fn sink_get_volume(_lua: &Lua, _: LuaValue) -> LuaResult<i64> {
    let mixer = alsa::Mixer::new("default", false).unwrap();

    let selem_name = "Master";
    let selem_id = SelemId::new(selem_name, 0);

    match mixer.find_selem(&selem_id) {
        Some(selem) => {
            let (min, max) = selem.get_playback_volume_range();

            let volume = selem
                .get_playback_volume(SelemChannelId::FrontLeft)
                .unwrap();

            let normalized = (volume as f64 - min as f64) / (max as f64 - min as f64);
            let percentage_int = (normalized * 100.0).round() as i64;

            Ok(percentage_int)
        }
        None => Ok(0),
    }
}

fn sink_set_volume(_lua: &Lua, value: i64) -> LuaResult<()> {
    if value < 0 || value > 100 {
        return Ok(());
    }

    let mixer = alsa::Mixer::new("default", false).unwrap();

    let selem_name = "Master";
    let selem_id = SelemId::new(selem_name, 0);

    match mixer.find_selem(&selem_id) {
        Some(selem) => {
            let (min, max) = selem.get_playback_volume_range();
            let target_norm = value as f64 / 100.0;
            let target_raw = ((min as f64 + target_norm) * (max as f64 - min as f64)).ceil() as i64;
            selem.set_playback_volume_all(target_raw).unwrap();
        }
        None => {}
    };

    Ok(())
}

fn source_get_volume(_lua: &Lua, _: LuaValue) -> LuaResult<i64> {
    let mixer = alsa::Mixer::new("default", false).unwrap();

    let selem_name = "Capture";
    let selem_id = SelemId::new(selem_name, 0);

    match mixer.find_selem(&selem_id) {
        Some(selem) => {
            let (min, max) = selem.get_capture_volume_range();

            let volume = selem.get_capture_volume(SelemChannelId::Unknown).unwrap();

            let normalized = (volume as f64 - min as f64) / (max as f64 - min as f64);
            Ok((normalized * 100.0) as i64)
        }
        None => Ok(0),
    }
}

fn source_set_volume(_lua: &Lua, value: i32) -> LuaResult<()> {
    if value < 0 || value > 100 {
        return Ok(());
    }

    let mixer = alsa::Mixer::new("default", false).unwrap();

    let selem_name = "Capture";
    let selem_id = SelemId::new(selem_name, 0);

    match mixer.find_selem(&selem_id) {
        Some(selem) => {
            let (min, max) = selem.get_capture_volume_range();
            let target_norm = value as f64 / 100.0;
            let target_raw = (min as f64 + target_norm * (max as f64 - min as f64)).round() as i64;

            selem.set_capture_volume_all(target_raw).unwrap();
        }
        None => {}
    }

    Ok(())
}

fn sink_is_muted(_lua: &Lua, _: LuaValue) -> LuaResult<bool> {
    let mixer = alsa::Mixer::new("default", false).unwrap();

    let selem_name = "Master";
    let selem_id = SelemId::new(selem_name, 0);
    match mixer.find_selem(&selem_id) {
        Some(selem) => Ok(selem
            .get_playback_switch(SelemChannelId::FrontLeft)
            .unwrap_or(0)
            == 0),
        None => Ok(false),
    }
}

fn sink_set_mute(_lua: &Lua, value: bool) -> LuaResult<()> {
    let mixer = alsa::Mixer::new("default", false).unwrap();

    let selem_name = "Master";
    let selem_id = SelemId::new(selem_name, 0);
    match mixer.find_selem(&selem_id) {
        Some(selem) => {
            let value_norm = match value {
                true => 0,
                false => 1,
            };

            selem.set_playback_switch_all(value_norm).unwrap();
        }
        None => {}
    }

    Ok(())
}

fn source_is_muted(_lua: &Lua, _: LuaValue) -> LuaResult<bool> {
    let mixer = alsa::Mixer::new("default", false).unwrap();

    let selem_name = "Capture";
    let selem_id = SelemId::new(selem_name, 0);
    match mixer.find_selem(&selem_id) {
        Some(selem) => Ok(selem.get_capture_switch(SelemChannelId::Unknown).unwrap() == 0),
        None => Ok(false),
    }
}

fn source_set_mute(_lua: &Lua, value: bool) -> LuaResult<()> {
    let mixer = alsa::Mixer::new("default", false).unwrap();

    let selem_name = "Capture";
    let selem_id = SelemId::new(selem_name, 0);
    match mixer.find_selem(&selem_id) {
        Some(selem) => {
            let value_norm = match value {
                true => 0,
                false => 1,
            };

            selem.set_capture_switch_all(value_norm).unwrap();
        }
        None => {}
    }

    Ok(())
}

fn subscribe(_lua: &Lua, callable: LuaValue) -> LuaResult<()> {
    let mixer = alsa::Mixer::new("default", false).unwrap();

    let mut fds = alsa::PollDescriptors::get(&mixer).unwrap();
    while let Ok(rc) = alsa::poll::poll(&mut fds, i32::MAX) {
        if rc == 0 {
            continue;
        }

        if let Ok(r) = mixer.handle_events() {
            if r == 1 {
                match callable.as_function() {
                    Some(value) => value.call(LuaValue::NULL).unwrap(),
                    None => {}
                };
            }
        }
    }

    Ok(())
}

#[mlua::lua_module]
fn libpa(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;

    exports.set("sink_get_volume", lua.create_function(sink_get_volume)?)?;
    exports.set("source_get_volume", lua.create_function(source_get_volume)?)?;

    exports.set("sink_set_volume", lua.create_function(sink_set_volume)?)?;
    exports.set("source_set_volume", lua.create_function(source_set_volume)?)?;

    exports.set("sink_is_muted", lua.create_function(sink_is_muted)?)?;
    exports.set("source_is_muted", lua.create_function(source_is_muted)?)?;

    exports.set("sink_set_mute", lua.create_function(sink_set_mute)?)?;
    exports.set("source_set_mute", lua.create_function(source_set_mute)?)?;

    exports.set("subscribe", lua.create_function(subscribe)?)?;

    Ok(exports)
}

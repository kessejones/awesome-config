use zbus::{Connection, Result, proxy};

#[proxy(
    interface = "org.awesomewm.audio",
    default_service = "org.awesomewm.audio",
    default_path = "/org/awesomewm/audio"
)]
trait AwesomeSession {
    async fn audio_event(&self) -> Result<()>;
}

#[tokio::main]
async fn main() -> Result<()> {
    let connection = Connection::session().await?;

    let proxy = AwesomeSessionProxy::new(&connection).await?;

    let mixer = alsa::Mixer::new("default", false).unwrap();

    let mut fds = alsa::PollDescriptors::get(&mixer).unwrap();
    while let Ok(rc) = alsa::poll::poll(&mut fds, i32::MAX) {
        if rc == 0 {
            continue;
        }

        if let Ok(r) = mixer.handle_events() {
            if r == 1 {
                proxy.audio_event().await?;
            }
        }
    }

    Ok(())
}

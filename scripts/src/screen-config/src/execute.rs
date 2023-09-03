use anyhow::{Context, Result};
use std::{io::Write, process::Command};

pub trait Execute {
    fn execute(&mut self) -> Result<()>;
}

impl Execute for Command {
    fn execute(&mut self) -> Result<()> {
        let output = self.output().context("failed to execute process")?;
        std::io::stdout().write_all(&output.stdout).context("failed to write to stdout")?;
        std::io::stderr().write_all(&output.stderr).context("failed to write to stderr")?;
        Ok(())
    }
}

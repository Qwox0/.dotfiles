use display_macro::display;

#[derive(Debug)]
pub enum Rotation {
    None,
    Left,
    Right,
    Inverted,
}

impl std::fmt::Display for Rotation {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                Rotation::None => "--rotate normal",
                Rotation::Left => "--rotate left",
                Rotation::Right => "--rotate right",
                Rotation::Inverted => "--rotate inverted",
            }
        )
    }
}

#[derive(Debug)]
#[display("{}{}: {}x{}+{}+{}", output, if self.is_primary {"*"} else {" "}, self.get_view_size().0, self.get_view_size().1, position.0, position.1)]
pub struct Monitor {
    pub output: String,
    pub is_primary: bool,
    pub resolution: (usize, usize),
    pub scale_factor: f64,
    pub rotation: Rotation,
    pub position: (usize, usize),
}

impl Monitor {
    pub fn new(output: impl Into<String>, resolution: (usize, usize)) -> Monitor {
        Monitor {
            output: output.into(),
            is_primary: false,
            resolution,
            scale_factor: 1.0,
            rotation: Rotation::None,
            position: (0, 0),
        }
    }

    pub fn scale(self, scale_factor: f64) -> Monitor {
        Monitor {
            scale_factor,
            ..self
        }
    }

    pub fn set_rotation(self, rotation: Rotation) -> Monitor {
        Monitor { rotation, ..self }
    }

    pub fn move_to(self, position: (usize, usize)) -> Monitor {
        Monitor { position, ..self }
    }

    pub fn set_primary(self) -> Monitor {
        Monitor {
            is_primary: true,
            ..self
        }
    }

    pub fn get_view_size(&self) -> (usize, usize) {
        let x = self.resolution.0 as f64 * self.scale_factor;
        let x = x as usize;
        let y = self.resolution.1 as f64 * self.scale_factor;
        let y = y as usize;

        match self.rotation {
            Rotation::None => (x, y),
            Rotation::Left => (y, x),
            Rotation::Right => (y, x),
            Rotation::Inverted => (x, y),
        }
    }

    pub fn as_args(&self) -> String {
        let is_primary = if self.is_primary { " --primary" } else { "" };
        let (x, y) = self.position;

        format!(
            "--output {0} --scale {1}x{1} --pos {x}x{y} {is_primary} {2}",
            self.output, self.scale_factor, self.rotation
        )
    }
}

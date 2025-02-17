/// Annotation used to mark a class for draft generation.
class Draft {
  const Draft({
    this.constructor,
  });

  final String? constructor;
}

/// A constant instance of [Draft].
const draft = Draft();

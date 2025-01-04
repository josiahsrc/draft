class SomeObject {
  final int value;

  const SomeObject(this.value);

  SomeObjectDraft draft() {
    return SomeObjectDraft(value);
  }

  SomeObject produce(void Function(SomeObjectDraft draft) fn) {
    final draft = this.draft();
    fn(draft);
    return draft.save();
  }
}

class SomeObjectDraft {
  int value;

  SomeObjectDraft(this.value);

  SomeObject save() {
    return SomeObject(value);
  }
}

void thing() {
  final obj = SomeObject(42);
  final draft = obj.draft();
  draft.value = 43;

  if (draft.value == 43) {
    draft.value *= 3;
  }

  final newObj = draft.save();
  print(newObj.value);

  print(obj.produce((draft) {
    draft.value = 44;
  }).value);
}

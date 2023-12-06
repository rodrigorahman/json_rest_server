enum IdTypeEnum {
  int,
  uuid;

  static IdTypeEnum parse(String? type) {
    switch (type) {
      case 'int':
        return IdTypeEnum.int;
      case 'uuid':
        return IdTypeEnum.uuid;
      default:
        return IdTypeEnum.int;
    }
  }
}

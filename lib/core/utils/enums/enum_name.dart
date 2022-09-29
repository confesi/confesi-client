/// Returns the lowercase name of an emum.
///
/// Ex: TestEnum test = TestEnum.hello;
/// print(getLowercaseEnumName(TestEnum)); -> "testenum".
String getLowercaseEnumName(Enum value) => value.toString().toLowerCase();

/// Returns the lowercase name of an emum.
///
/// Ex: TestEnum test = TestEnum.hello;
/// print(getLowercaseEnumName(TestEnum)); -> "testenum".
String getLowercaseEnumName(Type value) => value.toString().toLowerCase();

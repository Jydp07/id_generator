enum SnackbarType {
  info('Info'),
  error('Error'),
  success('Success');

  const SnackbarType(this.title);
  final String title;
}

enum FieldType { text, image, label }

enum IdCardType { preview, edit }

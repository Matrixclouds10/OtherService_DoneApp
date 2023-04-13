class ContactUsRequestsBody {
  final String _name;
  final String _subject;
  final String _email;
  final String _message;

  Map<String, dynamic> toJson() {
    return {
      "name": _name,
      "subject": _subject,
      "email": _email,
      "message": _message,
    };
  }

  const ContactUsRequestsBody({
    required String name,
    required String subject,
    required String email,
    required String message,
  })  : _name = name,
        _subject = subject,
        _email = email,
        _message = message;
}

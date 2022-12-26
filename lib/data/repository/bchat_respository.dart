import '../models/models.dart';
import '../services/bchat_api_service.dart';

class BChatRepository {
  static const successfull = 'success';

  final BChatApiService api;
  final String token;
  BChatRepository(this.api, this.token);

  Future<SearchContactBody?> searchContact(String term) async {
    final result = await api.searchContact(token, term);
    if (result.status == successfull) {
      return result.body;
    }
    return null;
  }

  Future<String?> addContact(SearchContactResult contact) async {
    final result = await api.addContact(token, contact.userId!.toString());
    if (result.status == successfull) {
      return null;
    }
    return result.message ?? 'Error while adding to contact';
  }

  Future<ContactsBody?> getContacts() async {
    final result = await api.getContacts(token);
    if (result.status == successfull) {
      return result.body;
    }
    return null;
  }
}

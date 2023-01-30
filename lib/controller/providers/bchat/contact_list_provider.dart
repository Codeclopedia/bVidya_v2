import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/core/state.dart';
import '/core/utils.dart';
import '/data/models/models.dart';
import '/data/services/bchat_api_service.dart';

final contactLoadingStateProvider = StateProvider<bool>((ref) => false);

final contactListProvider =
    StateNotifierProvider<ContactsListNotifier, List<Contacts>>(
        (ref) => ContactsListNotifier());

class ContactsListNotifier extends StateNotifier<List<Contacts>> {
  ContactsListNotifier() : super([]);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<int, Contacts> _contactsMap = {};

  Future<List<Contacts>> setup(WidgetRef ref) async {
    if (_isLoading) return state;
    _isLoading = true;
    // ref.read(contactLoadingStateProvider.notifier).state = _isLoading;
    final user = await getMeAsUser();
    if (user == null) {
      _isLoading = false;
      // ref.read(contactLoadingStateProvider.notifier).state = _isLoading;
      return [];
    }

    final ids = await BChatContactManager.getContactList();
    final result = await BChatApiService.instance
        .getContactsByIds(user.authToken, ids.join(','));
    if (result.body?.contacts?.isNotEmpty == true) {
      List<Contact> friends = result.body!.contacts!;
      for (Contact contact in friends) {
        if (ids.contains(contact.userId.toString())) {
          _contactsMap.addAll({
            contact.userId: Contacts.fromContact(contact, ContactStatus.friend)
          });
        }
      }
    }
    // List<Contact> friends =
    //     await ref.read(bChatProvider).getContactsByIds(ids.join(',')) ?? [];

    state = _contactsMap.values.toList();
    _isLoading = false;
    return state;
    // ref.read(contactLoadingStateProvider.notifier).state = _isLoading;
  }

  void addContactItem(Contacts contact) {
    _contactsMap.addAll({contact.userId: contact});
    state = _contactsMap.values.toList();
  }

  Future<Contacts?> addContact(int id) async {
    if (_contactsMap.containsKey(id)) {
      return _contactsMap[id];
    }
    final user = await getMeAsUser();
    if (user == null) {
      return null;
    }
    final result = await BChatApiService.instance
        .getContactsByIds(user.authToken, id.toString());
    if (result.body?.contacts?.isNotEmpty == true) {
      final contact =
          Contacts.fromContact(result.body!.contacts![0], ContactStatus.friend);
      _contactsMap.addAll({contact.userId: contact});
      state = _contactsMap.values.toList();
      return contact;
    }
    return null;
  }

  Contacts? removeContact(int id) {
    if (_contactsMap.containsKey(id)) {
      Contacts? contact = _contactsMap[id];
      _contactsMap.remove(id);
      state = _contactsMap.values.toList();
      return contact;
    }
    return null;
  }

  void clear() {
    _contactsMap.clear();
    state = [];
  }
}

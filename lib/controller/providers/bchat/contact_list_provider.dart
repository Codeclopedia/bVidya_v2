import '/core/utils/request_utils.dart';
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
    final requestIds = await ContactRequestHelper.getRequestList();
    final sendRequestIds = await ContactRequestHelper.getSendRequestList();
    final all = [...ids, ...requestIds, ...sendRequestIds];
    final result = await BChatApiService.instance
        .getContactsByIds(user.authToken, all.join(','));
    if (result.body?.contacts?.isNotEmpty == true) {
      List<Contact> friends = result.body!.contacts!;
      for (Contact contact in friends) {
        ContactStatus cStatus = ids.contains(contact.userId.toString())
            ? ContactStatus.friend
            : requestIds.contains(contact.userId.toString())
                ? ContactStatus.invited
                : ContactStatus.sentInvite;
        _contactsMap
            .addAll({contact.userId: Contacts.fromContact(contact, cStatus)});
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

  Future<Contacts?> addContact(int id, ContactStatus status) async {
    if (_contactsMap.containsKey(id)) {
      final con = _contactsMap[id];
      if (con?.status == status) {
        return con;
      } else if (con != null) {
        final contact = Contacts(
            name: con.name,
            profileImage: con.profileImage,
            userId: con.userId,
            status: status,
            bio: con.bio,
            email: con.bio,
            fcmToken: con.fcmToken,
            ispinned: con.ispinned,
            phone: con.phone,
            role: con.role);
        _contactsMap.addAll({contact.userId: contact});
        state = _contactsMap.values.toList();
        return contact;
      }
      // return _contactsMap[id];
    }
    final user = await getMeAsUser();
    if (user == null) {
      return null;
    }
    final result = await BChatApiService.instance
        .getContactsByIds(user.authToken, id.toString());
    if (result.body?.contacts?.isNotEmpty == true) {
      final contact = Contacts.fromContact(result.body!.contacts![0], status);
      _contactsMap.addAll({contact.userId: contact});
      state = _contactsMap.values.toList();
      return contact;
    }
    return null;
  }

  Future<Contacts?> addContactNewChat(int id) async {
    if (_contactsMap.containsKey(id)) {
      final con = _contactsMap[id];
      return con;
    }
    final user = await getMeAsUser();
    if (user == null) {
      return null;
    }
    final result = await BChatApiService.instance
        .getContactsByIds(user.authToken, id.toString());

    if (result.body?.contacts?.isNotEmpty == true) {
      final ids = await BChatContactManager.getContactList();
      final requestIds = await ContactRequestHelper.getRequestList();
      final sendRequestIds = await ContactRequestHelper.getSendRequestList();
      print('${sendRequestIds.length} -> $sendRequestIds');
      ContactStatus cStatus = ids.contains(id.toString())
          ? ContactStatus.friend
          : sendRequestIds.contains(id.toString())
              ? ContactStatus.sentInvite
              : requestIds.contains(id.toString())
                  ? ContactStatus.invited
                  : ContactStatus.friend;

      final contact = Contacts.fromContact(result.body!.contacts![0], cStatus);
      _contactsMap.addAll({contact.userId: contact});
      state = _contactsMap.values.toList();
      return contact;
    }
    return null;
  }

  Future addNewContact(Contacts contact) async {
    if (!_contactsMap.containsKey(contact.userId)) {
      _contactsMap.addAll({contact.userId: contact});
      state = _contactsMap.values.toList();
    }
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

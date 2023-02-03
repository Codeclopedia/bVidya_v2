import 'package:easy_image_viewer/easy_image_viewer.dart';

import '/controller/bchat_providers.dart';
// import '/core/constants/colors.dart';
import '/core/sdk_helpers/bchat_contact_manager.dart';
import '/ui/widgets.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

// import '../../widget/shimmer_tile.dart';
import '../blearn/components/common.dart';
// import 'widgets/chat_image_body.dart';

class ChatMediaGalleryScreen extends StatelessWidget {
  final Contacts contact;
  // final String title;
  const ChatMediaGalleryScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ColouredBoxBar(
      topBar: BAppBar(
        title: '${contact.name}\'s Media Files',
        // title: S.current.title_ViewAll,
      ),
      body: Consumer(builder: (context, ref, child) {
        return ref.watch(chatImageFiles(contact.userId.toString())).when(
              data: (data) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 3.w,
                        crossAxisSpacing: 2.w,
                        childAspectRatio: 0.8),
                    shrinkWrap: true,
                    itemCount: data.length,
                    cacheExtent: 100.w,
                    padding: EdgeInsets.symmetric(vertical: 5.w),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          final list = data
                              .map((e) => getImageProviderChatImage(e.body,
                                  loadThumbFirst: false))
                              .toList();
                          MultiImageProvider multiImageProvider =
                              MultiImageProvider(list, initialIndex: index);
                          showImageViewerPager(context, multiImageProvider,
                              onPageChanged: (page) {},
                              onViewerDismissed: (page) {});
                        },
                        child: chatImageBody(
                          data[index],
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) =>
                  buildEmptyPlaceHolder(S.current.error),
              loading: () => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return CustomizableShimmerTile(height: 40.w, width: 40.w);
                },
              ),
            );
      }),
    ));
  }

  Widget chatImageBody(
    ChatMediaFile file,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4.w)),
      child: Image(
        image: getImageProviderChatImage(file.body),
        fit: BoxFit.cover,
      ),
    );
  }
}

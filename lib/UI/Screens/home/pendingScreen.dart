import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraqdriver/repo/tracking_repo.dart';
import '../../../api/api_component.dart';
import '../../../controller/common_controller.dart';
import '../../../helper/shar_pref.dart';
import '../../../utils/image.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    getLanguage();
    getPendingTaskList();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
  }

  /// Pending Task List
  getPendingTaskList() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controller.getPendingTaskApi(context).then((value) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommonController>(builder: (commonController) {
      return Directionality(
        textDirection:
            (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 4,
            shadowColor: Colors.black38,
            title: Hero(
              tag: "pending",
              child: Material(
                child: Text(AppLocalizations.of(context)!.task,
                    style: TextStyle(
                        color: Color(0xFF070D17),
                        fontSize: 24,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF5F6979),
            ),
          ),
          body: (commonController.isLoading)
              ? showLoader()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Image(
                          image: AssetImage(Images.appIran),
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(height: 26),
                        Text(
                          "${AppLocalizations.of(context)!.pending} ${AppLocalizations.of(context)!.shipments}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.pendingTaskDes,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF404C5F)),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        (commonController.pendingTaskList!.isEmpty)
                            ? Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.noDataFound,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount:
                                    commonController.pendingTaskList!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: Image.asset(
                                                Images.completedIcon,
                                                height: 20),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .packageId,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffF79009),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                  Text(
                                                      "${commonController.pendingTaskList![index].packageId ?? '-'}",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffF79009),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                  Text(
                                                      "${commonController.pendingTaskList![index].deliveryStatus ?? '-'}",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffF79009),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ],
                                              )),
                                          const SizedBox(width: 12),
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .address,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffF79009),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                  Text(
                                                      "${commonController.pendingTaskList![index].flatNoBuildingName ?? '-'}",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffF79009),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                  Text(
                                                      "${commonController.pendingTaskList![index].cityTown ?? '-'} ${commonController.pendingTaskList![index].postalCode ?? ''}",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffF79009),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                                      (commonController
                                                      .pendingTaskList!.length -
                                                  1 ==
                                              index)
                                          ? const SizedBox()
                                          : const Divider(
                                              color: Colors.blueGrey)
                                    ],
                                  );
                                },
                              ),
                        SizedBox(height: Get.height * 0.095),
                      ],
                    ),
                  ),
                ),
          bottomSheet: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            height: MediaQuery.of(context).size.height * 0.08,
            child: CustomButtons(
              text: AppLocalizations.of(context)!.backToHome,
              onTap: () {
                Get.back();
              },
              noFillData: false,
            ),
          ),
        ),
      );
    });
  }
}

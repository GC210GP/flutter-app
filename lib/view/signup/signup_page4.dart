import 'dart:io';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ip;

class SignPage4 extends StatefulWidget {
  final Function(String, String)? onPressed;
  final VoidCallback? onBackPressed;
  final String? imgUrl;
  final String label;

  const SignPage4({
    Key? key,
    required this.label,
    this.onPressed,
    this.onBackPressed,
    this.imgUrl,
  }) : super(key: key);

  @override
  State<SignPage4> createState() => _SignPage4State();
}

class _SignPage4State extends State<SignPage4> {
  late String imgUrl;
  TextEditingController _controller = TextEditingController();
  String textField = "";

  double pageOpacity = 0.0;

  bool isError = false;
  bool isImageUploading = false;

  @override
  void initState() {
    imgUrl = widget.imgUrl ?? GlobalVariables.defaultImgUrl;
    _controller.text = textField;
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      pageOpacity = 1.0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SizedBox(
            width: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "계정을 생성합니다",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: DDFontFamily.nanumSR,
                      fontWeight: DDFontWeight.extraBold,
                      fontSize: DDFontSize.h15,
                      color: DDColor.fontColor,
                    ),
                  ),
                ),

                const SizedBox(height: 50.0),

                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(.0),
                      onPressed: () async {
                        imgUrl =
                            await pickImage() ?? GlobalVariables.defaultImgUrl;
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Image(
                              image: NetworkImage(imgUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              alignment: Alignment.center,
                              height: 25.0,
                              width: 100.0,
                              color: Colors.black.withOpacity(0.2),
                              child: const Text(
                                "편집",
                                style: TextStyle(
                                  fontFamily: DDFontFamily.nanumSR,
                                  fontWeight: DDFontWeight.bold,
                                  fontSize: DDFontSize.h5,
                                  color: DDColor.white,
                                ),
                              ),
                            ),
                          ),
                          if (isImageUploading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.white.withOpacity(0.5),
                                child: const CupertinoActivityIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25.0),

                Center(
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: DDFontFamily.nanumSR,
                      fontWeight: DDFontWeight.extraBold,
                      fontSize: DDFontSize.h4,
                      color: DDColor.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 10.0),

                DDTextField(
                  controller: _controller,
                  onChanged: (value) => textField = value,
                ),

                const SizedBox(height: 10.0),

                if (isError)
                  Center(
                    child: Text(
                      "최소 한 글자 이상 입력해주세요!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h5,
                        color: DDColor.primary,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 14.5),

                const SizedBox(height: 25.0),

                Center(
                  child: DDButton(
                    width: 80,
                    label: "확인",
                    onPressed: () async {
                      if (_controller.text.isEmpty) {
                        setState(() {
                          isError = true;
                        });
                        return;
                      }

                      if (widget.onPressed != null) {
                        pageOpacity = 0.0;
                        setState(() {});
                        await Future.delayed(const Duration(milliseconds: 100));

                        widget.onPressed!(textField, imgUrl);
                        textField = "";
                        _controller.text = "";
                        pageOpacity = 1.0;
                        setState(() {});
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20.0),

                if (widget.onBackPressed != null)
                  Center(
                    child: DDButton(
                      width: 40.0,
                      height: 40.0,
                      child: const Icon(Icons.arrow_back_rounded),
                      onPressed: () async {
                        if (widget.onBackPressed != null) {
                          pageOpacity = 0.0;
                          setState(() {});
                          await Future.delayed(
                              const Duration(milliseconds: 100));

                          widget.onBackPressed!();

                          textField = "";
                          _controller.text = "";
                          isError = false;
                          pageOpacity = 1.0;
                          setState(() {});
                        }
                      },
                      color: DDColor.disabled,
                    ),
                  )
                else
                  const SizedBox(height: 40.0),

                ///
                ///
                ///
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    File? image;
    String? _imgUrl;

    setState(() {
      isImageUploading = true;
    });

    if (pickedFile != null) {
      image = File(pickedFile.path);

      // Read a jpeg image from file.
      ip.Image? imageResize = ip.decodeImage(image.readAsBytesSync());
      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      ip.Image thumbnail =
          ip.copyResize(imageResize!, width: GlobalVariables.uploadImgWidth);
      // Save the thumbnail as a PNG.

      image.writeAsBytesSync(ip.encodeJpg(thumbnail));
      debugPrint("${await image.length()}");
    }

    Map<String, dynamic> result;
    if (image != null) {
      result = await HttpConn().put(
        apiUrl: "/files/upload",
        files: [image],
      );
      _imgUrl = result["files"][0];
    }

    setState(() {
      isImageUploading = false;
    });

    return _imgUrl;
  }
}

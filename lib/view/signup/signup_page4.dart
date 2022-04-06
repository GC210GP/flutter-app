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
  final VoidCallback? onPressed;
  final VoidCallback? onBackPressed;

  const SignPage4({
    Key? key,
    this.onPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<SignPage4> createState() => _SignPage4State();
}

class _SignPage4State extends State<SignPage4> {
  String imgUrl = GlobalVariables.defaultImgUrl;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    onPressed: pickImage,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Image(
                            image: NetworkImage(imgUrl),
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
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25.0),

              Center(
                child: Text(
                  "닉네임",
                  style: TextStyle(
                    fontFamily: DDFontFamily.nanumSR,
                    fontWeight: DDFontWeight.extraBold,
                    fontSize: DDFontSize.h4,
                    color: DDColor.grey,
                  ),
                ),
              ),

              const SizedBox(height: 10.0),

              DDTextField(),

              const SizedBox(height: 50.0),

              Center(
                child: DDButton(
                  width: 80,
                  label: "확인",
                  onPressed: widget.onPressed,
                ),
              ),

              const SizedBox(height: 20.0),

              Center(
                child: DDButton(
                  width: 40.0,
                  height: 40.0,
                  label: "←",
                  onPressed: widget.onBackPressed,
                  color: DDColor.disabled,
                ),
              ),

              ///
              ///
              ///
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    File? image;

    if (pickedFile != null) {
      image = File(pickedFile.path);

      // Read a jpeg image from file.
      ip.Image? imageResize = ip.decodeImage(image.readAsBytesSync());
      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      ip.Image thumbnail = ip.copyResize(imageResize!, width: 120);
      // Save the thumbnail as a PNG.

      image.writeAsBytesSync(ip.encodePng(thumbnail));
      print(image.length());
      image.writeAsBytesSync(ip.encodeJpg(thumbnail));
      print(image.length());
    }

    Map<String, dynamic> result;
    if (image != null) {
      result = await HttpConn().put(
        apiUrl: "/files/upload",
        files: [image],
      );
      imgUrl = result["files"][0];
      setState(() {});
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';
import '../widgets/change_gender_dialog_widget.dart';
import '../widgets/text_form_field_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _dataAccount;
  String genderRole;

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final profileProv = Provider.of<ProfileProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Profil"),
        ),
        body: StreamBuilder(
            stream: profileProv.getDocumentById(authProv.userModel.id),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());
                  break;
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Center(child: Text('Something error'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No Data'));
                  }
                  break;
                case ConnectionState.active:
                  var user = snapshot.data;
                  _dataAccount = user;
                  genderRole = user['role'];
                  break;

                default:
              }
              var user = snapshot.data;
              return Container(
                child: SingleChildScrollView(
                  child: genderRole == "Pasien"
                      ? Column(
                          children: <Widget>[
                            Center(
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    profileProv
                                        .selectImage()
                                        .then((value) =>
                                            profileProv.uploadImage(
                                                imageToUpload:
                                                    profileProv.imageFile,
                                                title: profileProv.imageFile
                                                    .toString()))
                                        .then((value) {
                                      profileProv.updateDocumentPasien(
                                          authProv.userModel.id,
                                          {"image": profileProv.urlImage});
                                      profileProv.updateDocumentUser(
                                          authProv.userModel.id,
                                          {"image": profileProv.urlImage});
                                    }).then((value) => profileProv.clear());
                                  },
                                  child: profileProv.imageFile != null
                                      ? CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage:
                                              FileImage(profileProv.imageFile),
                                        )
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.black12,
                                          backgroundImage: NetworkImage(
                                            user['image'] ??
                                                'https://i.pinimg.com/564x/51/f6/fb/51f6fb256629fc755b8870c801092942.jpg',
                                          ),
                                        ),
                                ),
                                title: GestureDetector(
                                  onTap: () {
                                    changeNameDialog(
                                        context: context,
                                        profileProv: profileProv,
                                        user: user,
                                        authProv: authProv,
                                        role: _dataAccount['role']);
                                  },
                                  child: Text(
                                    user['username'] ?? '',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 17,
                                    ),
                                    Text(
                                      user['role'] == 'Pasien'
                                          ? 'Pasien'
                                          : 'Pendonor',
                                      style: kText,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Container(
                                width: 300,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 30),
                                    profileItem(
                                      title: 'Jenis Kelamin',
                                      value: user['jenisKelamin'],
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ChangeGenderDialog(
                                              genderRole: genderRole,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    profileItem(
                                      title: 'No. Telepon/HP',
                                      value: user['noHp'],
                                      onTap: () {
                                        changeNoHpDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    profileItem(
                                      title: 'Golongan Darah',
                                      value: user['golonganDarah'],
                                      onTap: () {
                                        changeGolonganDarahDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    profileItem(
                                      title: 'Alamat',
                                      value: user['alamat'],
                                      onTap: () {
                                        changeAlamatDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    profileItem(
                                      title: 'Tanggal Membutuhkan',
                                      value: user['tanggalMembutuhkan'],
                                      onTap: () {
                                        changeTanggalMembutuhkanDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        changeMembutuhkanDarahDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Membutuhkan Darah"),
                                          Container(
                                              width: 150,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                  "${user['membutuhkanDarah'] ?? '0'} kantong" ??
                                                      "Error"))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Center(
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    profileProv
                                        .selectImage()
                                        .then((value) =>
                                            profileProv.uploadImage(
                                                imageToUpload:
                                                    profileProv.imageFile,
                                                title: profileProv.imageFile
                                                    .toString()))
                                        .then((value) {
                                      profileProv.updateDocumentUser(
                                          authProv.userModel.id,
                                          {"image": profileProv.urlImage});
                                      profileProv.updateDocumentPendonor(
                                          authProv.userModel.id,
                                          {"image": profileProv.urlImage});

                                      profileProv.clear();
                                    });
                                  },
                                  child: profileProv.imageFile != null
                                      ? CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage:
                                              FileImage(profileProv.imageFile),
                                        )
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.black12,
                                          backgroundImage: NetworkImage(
                                            user['image'] ??
                                                'https://i.pinimg.com/564x/51/f6/fb/51f6fb256629fc755b8870c801092942.jpg',
                                          ),
                                        ),
                                ),
                                title: GestureDetector(
                                  onTap: () {
                                    changeNameDialog(
                                      context: context,
                                      profileProv: profileProv,
                                      user: user,
                                      authProv: authProv,
                                      role: _dataAccount['role'],
                                    );
                                  },
                                  child: Text(
                                    user['username'] ?? '',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 17,
                                    ),
                                    Text(
                                      user['role'] == 'Pasien'
                                          ? 'Pasien'
                                          : 'Pendonor',
                                      style: kText,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Container(
                                width: 300,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 30),
                                    profileItem(
                                      title: 'Jenis Kelamin',
                                      value: user['jenisKelamin'],
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ChangeGenderDialog(
                                              genderRole: genderRole,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    profileItem(
                                      title: 'No. Telepon/HP',
                                      value: user['noHp'],
                                      onTap: () {
                                        changeNoHpDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    profileItem(
                                      title: 'Golongan Darah',
                                      value: user['golonganDarah'],
                                      onTap: () {
                                        changeGolonganDarahDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    profileItem(
                                      title: 'Alamat',
                                      value: user['alamat'],
                                      onTap: () {
                                        changeAlamatDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    profileItem(
                                      title: 'Tanggal Membutuhkan',
                                      value: user['tanggalMembutuhkan'],
                                      onTap: () {
                                        changeTanggalMembutuhkanDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        changeMembutuhkanDarahDialog(
                                          context: context,
                                          profileProv: profileProv,
                                          user: user,
                                          authProv: authProv,
                                          role: _dataAccount['role'],
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Membutuhkan Darah"),
                                          Container(
                                              width: 150,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                  "${user['membutuhkanDarah'] ?? '0'} kantong" ??
                                                      "Error"))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    _dataAccount['role'] == 'Pasien'
                        ? 'Apakah kamu yakin ingin mengubah status menjadi Pendonor?'
                        : 'Apakah kamu yakin ingin mengubah status menjadi Pasien?',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Batal'),
                      onPressed: () {
                        Get.back();
                      },
                      color: kGreyColor,
                    ),
                    FlatButton(
                      child: Text('Ya, saya yakin'),
                      onPressed: () {
                        if (_dataAccount['role'] == "Pasien") {
                          profileProv
                              .updateDocumentUser(authProv.userModel.id, {
                                "role": "Pendonor",
                              })
                              .then((value) => authProv.setPendonorDocument(
                                    authProv.userModel.id,
                                    {
                                      /// [ADD] here if user need more data
                                      "username": _dataAccount['username'],
                                      "email": _dataAccount['email'],
                                      "image": _dataAccount['image'],
                                      "role": _dataAccount['role'],
                                      "alamat": _dataAccount['alamat'],
                                      "golonganDarah":
                                          _dataAccount['golonganDarah'],
                                      "jenisKelamin":
                                          _dataAccount['jenisKelamin'],
                                      "membutuhkanDarah":
                                          _dataAccount['membutuhkanDarah'],
                                      "noHp": _dataAccount['noHp'],
                                      "tanggalMembutuhkan":
                                          _dataAccount['tanggalMembutuhkan'],
                                    },
                                  ))
                              .then((value) => profileProv
                                  .removeDocumentPasien(authProv.userModel.id))
                              .then((value) => Get.back());
                        } else if (_dataAccount['role'] == "Pendonor") {
                          profileProv
                              .updateDocumentUser(authProv.userModel.id, {
                                "role": "Pasien",
                              })
                              .then((value) => authProv.setPasienDocument(
                                    authProv.userModel.id,
                                    {
                                      /// [ADD] here if user need more data
                                      /// [ADD] here if user need more data
                                      "username": _dataAccount['username'],
                                      "email": _dataAccount['email'],
                                      "image": _dataAccount['image'],
                                      "role": _dataAccount['role'],
                                      "alamat": _dataAccount['alamat'],
                                      "golonganDarah":
                                          _dataAccount['golonganDarah'],
                                      "jenisKelamin":
                                          _dataAccount['jenisKelamin'],
                                      "membutuhkanDarah":
                                          _dataAccount['membutuhkanDarah'],
                                      "noHp": _dataAccount['noHp'],
                                      "tanggalMembutuhkan":
                                          _dataAccount['tanggalMembutuhkan'],
                                    },
                                  ))
                              .then((value) =>
                                  profileProv.removeDocumentPendonor(
                                      authProv.userModel.id))
                              .then((value) => Get.back());
                        }
                      },
                      color: kPrimaryColor,
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: kPrimaryColor,
          label: Row(
            children: <Widget>[
              Icon(Icons.swap_horiz, color: kWhiteColor),
              SizedBox(width: 12.0),
              Text(
                'Ganti Status',
                style: kDescription.copyWith(color: kWhiteColor),
              )
            ],
          ),
        ));
  }

  Future changeMembutuhkanDarahDialog(
      {context, profileProv, user, authProv, role}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ganti Jumlah Darah'),
          content: Form(
            key: profileProv.formKey,
            autovalidate: profileProv.autoValidate,
            child: TextFormFieldWidget(
              validator: profileProv.validateText,
              obscureText: false,
              initialValue: user['membutuhkanDarah'],
              keyboardType: TextInputType.number,
              prefixIcon: Icon(FlutterIcons.blood_bag_mco),
              hintText: 'Masukkan total',
              onChanged: (value) => profileProv.membutuhkanDarahChanged(value),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () {
                Get.back();
              },
              color: kGreyColor,
            ),
            FlatButton(
              child: Text('Simpan'),
              onPressed: () {
                if (profileProv.formKey.currentState.validate()) {
                  profileProv.formKey.currentState.save();
                  profileProv.updateDocumentUser(authProv.userModel.id, {
                    "membutuhkanDarah": profileProv.membutuhkanDarah,
                  }).then((value) {
                    if (role == 'Pendonor') {
                      profileProv
                          .updateDocumentPendonor(authProv.userModel.id, {
                        "membutuhkanDarah": profileProv.membutuhkanDarah,
                      });
                    } else if (role == 'Pasien') {
                      profileProv.updateDocumentPasien(authProv.userModel.id, {
                        "membutuhkanDarah": profileProv.membutuhkanDarah,
                      });
                    }
                  }).then((value) => Get.back());
                  profileProv.autoValidate = false;
                } else {
                  profileProv.autoValidate = true;
                }
              },
              color: kPrimaryColor,
            ),
          ],
        );
      },
    );
  }

  Future changeTanggalMembutuhkanDialog(
      {context, profileProv, user, authProv, role}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ganti Tanggal Membutuhkan'),
          content: Form(
            key: profileProv.formKey,
            autovalidate: profileProv.autoValidate,
            child: TextFormFieldWidget(
              validator: profileProv.validateText,
              obscureText: false,
              initialValue: user['tanggalMembutuhkan'],
              keyboardType: TextInputType.text,
              prefixIcon: Icon(Icons.date_range),
              hintText: 'Masukkan Tanggal',
              onChanged: (value) =>
                  profileProv.tanggalMembutuhkanChanged(value),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () {
                Get.back();
              },
              color: kGreyColor,
            ),
            FlatButton(
              child: Text('Simpan'),
              onPressed: () {
                if (profileProv.formKey.currentState.validate()) {
                  profileProv.formKey.currentState.save();
                  profileProv.updateDocumentUser(authProv.userModel.id, {
                    "tanggalMembutuhkan": profileProv.tanggalMembutuhkan,
                  }).then((value) {
                    if (role == 'Pendonor') {
                      profileProv
                          .updateDocumentPendonor(authProv.userModel.id, {
                        "tanggalMembutuhkan": profileProv.tanggalMembutuhkan,
                      });
                    } else if (role == 'Pasien') {
                      profileProv.updateDocumentPasien(authProv.userModel.id, {
                        "tanggalMembutuhkan": profileProv.tanggalMembutuhkan,
                      });
                    }
                  }).then((value) => Get.back());
                  profileProv.autoValidate = false;
                } else {
                  profileProv.autoValidate = true;
                }
              },
              color: kPrimaryColor,
            ),
          ],
        );
      },
    );
  }

  Future changeAlamatDialog({context, profileProv, user, authProv, role}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ganti Alamat'),
          content: Form(
            key: profileProv.formKey,
            autovalidate: profileProv.autoValidate,
            child: TextFormFieldWidget(
              validator: profileProv.validateText,
              obscureText: false,
              initialValue: user['alamat'],
              keyboardType: TextInputType.text,
              prefixIcon: Icon(Icons.location_on),
              hintText: 'Masukkan Alamat Lengkap',
              onChanged: (value) => profileProv.alamatChanged(value),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () {
                Get.back();
              },
              color: kGreyColor,
            ),
            FlatButton(
              child: Text('Simpan'),
              onPressed: () {
                if (profileProv.formKey.currentState.validate()) {
                  profileProv.formKey.currentState.save();
                  profileProv.updateDocumentUser(authProv.userModel.id, {
                    "alamat": profileProv.alamat,
                  }).then((value) {
                    if (role == 'Pendonor') {
                      print(role);
                      profileProv
                          .updateDocumentPendonor(authProv.userModel.id, {
                        "alamat": profileProv.alamat,
                      });
                    } else if (role == 'Pasien') {
                      profileProv.updateDocumentPasien(authProv.userModel.id, {
                        "alamat": profileProv.alamat,
                      });
                    }
                  }).then((value) => Get.back());
                  profileProv.autoValidate = false;
                } else {
                  profileProv.autoValidate = true;
                }
              },
              color: kPrimaryColor,
            ),
          ],
        );
      },
    );
  }

  Future changeGolonganDarahDialog(
      {context, profileProv, user, authProv, role}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ganti Golongan Darah'),
          content: Form(
            key: profileProv.formKey,
            autovalidate: profileProv.autoValidate,
            child: TextFormFieldWidget(
              validator: profileProv.validateText,
              obscureText: false,
              initialValue: user['golonganDarah'],
              keyboardType: TextInputType.text,
              prefixIcon: Icon(FlutterIcons.blood_bag_mco),
              hintText: 'Masukkan Golongan Darah',
              onChanged: (value) => profileProv.golonganDarahChanged(value),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () {
                Get.back();
              },
              color: kGreyColor,
            ),
            FlatButton(
              child: Text('Simpan'),
              onPressed: () {
                if (profileProv.formKey.currentState.validate()) {
                  profileProv.formKey.currentState.save();
                  profileProv.updateDocumentUser(authProv.userModel.id, {
                    "golonganDarah": profileProv.golonganDarah,
                  }).then((value) {
                    if (role == 'Pendonor') {
                      print(role);
                      profileProv
                          .updateDocumentPendonor(authProv.userModel.id, {
                        "golonganDarah": profileProv.golonganDarah,
                      });
                    } else if (role == 'Pasien') {
                      profileProv.updateDocumentPasien(authProv.userModel.id, {
                        "golonganDarah": profileProv.golonganDarah,
                      });
                    }
                  }).then((value) => Get.back());

                  profileProv.autoValidate = false;
                } else {
                  profileProv.autoValidate = true;
                }
              },
              color: kPrimaryColor,
            ),
          ],
        );
      },
    );
  }

  Future changeNoHpDialog(
      {context, profileProv, user, AuthProvider authProv, role}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ganti No. Hp'),
          content: Form(
            key: profileProv.formKey,
            autovalidate: profileProv.autoValidate,
            child: TextFormFieldWidget(
              validator: profileProv.validateNoHp,
              obscureText: false,
              initialValue: user['noHp'],
              keyboardType: TextInputType.number,
              prefixIcon: Icon(Icons.phone),
              hintText: 'Masukkan No. Hp',
              onChanged: (value) => profileProv.noHpChanged(value),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () {
                Get.back();
              },
              color: kGreyColor,
            ),
            FlatButton(
              child: Text('Simpan'),
              onPressed: () {
                if (profileProv.formKey.currentState.validate()) {
                  profileProv.formKey.currentState.save();
                  profileProv.updateDocumentUser(authProv.userModel.id, {
                    "noHp": profileProv.noHp,
                  }).then((value) {
                    if (role == 'Pendonor') {
                      print(role);
                      profileProv
                          .updateDocumentPendonor(authProv.userModel.id, {
                        "noHp": profileProv.noHp,
                      });
                    } else if (role == 'Pasien') {
                      profileProv.updateDocumentPasien(authProv.userModel.id, {
                        "noHp": profileProv.noHp,
                      });
                    }
                  }).then((value) => Get.back());
                  profileProv.autoValidate = false;
                } else {
                  profileProv.autoValidate = true;
                }
              },
              color: kPrimaryColor,
            ),
          ],
        );
      },
    );
  }

  Future changeNameDialog(
      {BuildContext context,
      ProfileProvider profileProv,
      user,
      AuthProvider authProv,
      role}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ganti Nama'),
          content: Form(
            key: profileProv.formKey,
            autovalidate: profileProv.autoValidate,
            child: TextFormFieldWidget(
              validator: profileProv.validateText,
              obscureText: false,
              initialValue: user['username'],
              keyboardType: TextInputType.text,
              prefixIcon: Icon(Icons.account_circle),
              hintText: 'Masukkan Nama Lengkap',
              onChanged: (value) => profileProv.usernameChanged(value),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () {
                Get.back();
              },
              color: kGreyColor,
            ),
            FlatButton(
              child: Text('Simpan'),
              onPressed: () {
                if (profileProv.formKey.currentState.validate()) {
                  profileProv.formKey.currentState.save();

                  profileProv.updateDocumentUser(authProv.userModel.id, {
                    "username": profileProv.username,
                  }).then((value) {
                    if (role == 'Pendonor') {
                      print(role);
                      profileProv
                          .updateDocumentPendonor(authProv.userModel.id, {
                        "username": profileProv.username,
                      });
                    } else if (role == 'Pasien') {
                      profileProv.updateDocumentPasien(authProv.userModel.id, {
                        "username": profileProv.username,
                      });
                    }
                  }).then((value) => Get.back());

                  profileProv.autoValidate = false;
                } else {
                  profileProv.autoValidate = true;
                }
              },
              color: kPrimaryColor,
            ),
          ],
        );
      },
    );
  }

  profileItem({String title, String value, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: kDescription,
          ),
          Container(
            width: 150,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(value ?? '-'),
          )
        ],
      ),
    );
  }
}

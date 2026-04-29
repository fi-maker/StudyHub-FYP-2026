import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


pickImage(ImageSource source) async{
  final ImagePicker imagePicker = ImagePicker();
  XFile? _file =await imagePicker.pickImage(source:source);
  if(_file != null){
    return await _file.readAsBytes();



  }
  print('No image selected');
  return null;


}

bool isApplicationValid(Map<String, dynamic> data) {
  // firstname
  final firstName = (data['firstname'] ?? '').toString().trim();
  if (firstName.isEmpty) return false;

  // lastname
  final lastName = (data['lastname'] ?? '').toString().trim();
  if (lastName.isEmpty) return false;

  // CNIC (remove dashes)
  final cnic = (data['cnic'] ?? '').toString().replaceAll('-', '').trim();
  if (cnic.length != 13) return false; // CNIC digits should be 13

  // email
  final email = (data['stuemail'] ?? '').toString().trim();
  if (!email.contains('@') || !email.contains('.')) return false;

  // Matric marks (allow int or string)
  final matric = data['Matricmarks'];
  if (matric == '500' || matric.toString().trim().isEmpty) return false;

  // Matric marks (allow int or string)
  final uni = data['DegreeMarks'];
  if (uni == '2.0' || matric.toString().trim().isEmpty) return false;

  //intermarks
  final inter = data['Intermarks'];
  if (inter == '500' || matric.toString().trim().isEmpty) return false;

  return true;
}

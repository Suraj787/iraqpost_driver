// To parse this JSON data, do
//
//     final barcodeScanModel = barcodeScanModelFromJson(jsonString);

import 'dart:convert';

BarcodeScanModel barcodeScanModelFromJson(String str) => BarcodeScanModel.fromJson(json.decode(str));

String barcodeScanModelToJson(BarcodeScanModel data) => json.encode(data.toJson());

class BarcodeScanModel {
  String? message;
  BarcodeScanData? barcodeScanData;

  BarcodeScanModel({
    this.message,
    this.barcodeScanData,
  });

  factory BarcodeScanModel.fromJson(Map<String, dynamic> json) => BarcodeScanModel(
    message: json["message"],
    barcodeScanData: json["data"] == null ? null : BarcodeScanData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": barcodeScanData?.toJson(),
  };
}

class BarcodeScanData {
  DateTime? time;
  List<BarcodeDetail>? barcodeDetail;

  BarcodeScanData({
    this.time,
    this.barcodeDetail,
  });

  factory BarcodeScanData.fromJson(Map<String, dynamic> json) => BarcodeScanData(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    barcodeDetail: json["data"] == null ? [] : List<BarcodeDetail>.from(json["data"]!.map((x) => BarcodeDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "data": barcodeDetail == null ? [] : List<dynamic>.from(barcodeDetail!.map((x) => x.toJson())),
  };
}

class BarcodeDetail {
  String? name;
  DateTime? creation;
  DateTime? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  dynamic userTags;
  dynamic comments;
  dynamic assign;
  dynamic likedBy;
  dynamic amendedFrom;
  String? customer;
  String? pickupType;
  DateTime? requestDate;
  String? status;
  dynamic pickupLocation;
  dynamic destinationLocation;
  String? address;
  String? contact;
  dynamic pickDate;
  dynamic address1;
  dynamic contact1;
  dynamic pickupFromTime;
  dynamic pickupToTime;
  String? shipmentType;
  String? serviceType;
  dynamic specialInstructions;
  dynamic pickupTimeFromTime;
  dynamic pickupTimeToTime;
  String? mobileNo;
  dynamic flatNoBuildingName;
  dynamic cityTown;
  dynamic landmark;
  dynamic contactPersonNumber;
  String? fromTime;
  String? toTime;
  dynamic addressDispaly;
  String? assignedToDriver;
  String? assignedToVehicle;
  dynamic longitude;
  dynamic latitude;
  dynamic pickupLongitude;
  dynamic pickupLatitude;
  String? destinationLongitude;
  String? destinationLatitude;
  String? namingSeries;
  dynamic lead;
  dynamic enquiry;
  dynamic quotation;
  dynamic salesOrder;
  dynamic purchaseOrder;
  dynamic deliveryNote;
  String? postOffice;
  dynamic hub;
  String? isPaid;
  dynamic modePfPayment;
  String? modeOfPayment;
  String? receivedAt;
  dynamic postOfficehub;
  dynamic servicePartner;
  dynamic documentBarcode;
  dynamic deliveredTime;
  dynamic validation;
  String? postalCode;

  BarcodeDetail({
    this.name,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.owner,
    this.docstatus,
    this.idx,
    this.userTags,
    this.comments,
    this.assign,
    this.likedBy,
    this.amendedFrom,
    this.customer,
    this.pickupType,
    this.requestDate,
    this.status,
    this.pickupLocation,
    this.destinationLocation,
    this.address,
    this.contact,
    this.pickDate,
    this.address1,
    this.contact1,
    this.pickupFromTime,
    this.pickupToTime,
    this.shipmentType,
    this.serviceType,
    this.specialInstructions,
    this.pickupTimeFromTime,
    this.pickupTimeToTime,
    this.mobileNo,
    this.flatNoBuildingName,
    this.cityTown,
    this.landmark,
    this.contactPersonNumber,
    this.fromTime,
    this.toTime,
    this.addressDispaly,
    this.assignedToDriver,
    this.assignedToVehicle,
    this.longitude,
    this.latitude,
    this.pickupLongitude,
    this.pickupLatitude,
    this.destinationLongitude,
    this.destinationLatitude,
    this.namingSeries,
    this.lead,
    this.enquiry,
    this.quotation,
    this.salesOrder,
    this.purchaseOrder,
    this.deliveryNote,
    this.postOffice,
    this.hub,
    this.isPaid,
    this.modePfPayment,
    this.modeOfPayment,
    this.receivedAt,
    this.postOfficehub,
    this.servicePartner,
    this.documentBarcode,
    this.deliveredTime,
    this.validation,
    this.postalCode,
  });

  factory BarcodeDetail.fromJson(Map<String, dynamic> json) => BarcodeDetail(
    name: json["name"],
    creation: json["creation"] == null ? null : DateTime.parse(json["creation"]),
    modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
    modifiedBy: json["modified_by"],
    owner: json["owner"],
    docstatus: json["docstatus"],
    idx: json["idx"],
    userTags: json["_user_tags"],
    comments: json["_comments"],
    assign: json["_assign"],
    likedBy: json["_liked_by"],
    amendedFrom: json["amended_from"],
    customer: json["customer"],
    pickupType: json["pickup_type"],
    requestDate: json["request_date"] == null ? null : DateTime.parse(json["request_date"]),
    status: json["status"],
    pickupLocation: json["pickup_location"],
    destinationLocation: json["destination_location"],
    address: json["address"],
    contact: json["contact"],
    pickDate: json["pick_date"],
    address1: json["address_1"],
    contact1: json["contact_1"],
    pickupFromTime: json["pickup_from_time"],
    pickupToTime: json["pickup_to_time"],
    shipmentType: json["shipment_type"],
    serviceType: json["service_type"],
    specialInstructions: json["special_instructions"],
    pickupTimeFromTime: json["pickup_time_from_time"],
    pickupTimeToTime: json["pickup_time_to_time"],
    mobileNo: json["mobile_no"],
    flatNoBuildingName: json["flat_no_building_name"],
    cityTown: json["city_town"],
    landmark: json["landmark"],
    contactPersonNumber: json["contact_person_number"],
    fromTime: json["from_time"],
    toTime: json["to_time"],
    addressDispaly: json["address_dispaly"],
    assignedToDriver: json["assigned_to_driver"],
    assignedToVehicle: json["assigned_to_vehicle"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    pickupLongitude: json["pickup_longitude"],
    pickupLatitude: json["pickup_latitude"],
    destinationLongitude: json["destination_longitude"],
    destinationLatitude: json["destination_latitude"],
    namingSeries: json["naming_series"],
    lead: json["lead"],
    enquiry: json["enquiry"],
    quotation: json["quotation"],
    salesOrder: json["sales_order"],
    purchaseOrder: json["purchase_order"],
    deliveryNote: json["delivery_note"],
    postOffice: json["post_office"],
    hub: json["hub"],
    isPaid: json["is_paid"],
    modePfPayment: json["mode_pf_payment"],
    modeOfPayment: json["mode_of_payment"],
    receivedAt: json["received_at"],
    postOfficehub: json["post_officehub"],
    servicePartner: json["service_partner"],
    documentBarcode: json["document_barcode"],
    deliveredTime: json["delivered_time"],
    validation: json["validation"],
    postalCode: json["postal_code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "creation": creation?.toIso8601String(),
    "modified": modified?.toIso8601String(),
    "modified_by": modifiedBy,
    "owner": owner,
    "docstatus": docstatus,
    "idx": idx,
    "_user_tags": userTags,
    "_comments": comments,
    "_assign": assign,
    "_liked_by": likedBy,
    "amended_from": amendedFrom,
    "customer": customer,
    "pickup_type": pickupType,
    "request_date": requestDate?.toIso8601String(),
    "status": status,
    "pickup_location": pickupLocation,
    "destination_location": destinationLocation,
    "address": address,
    "contact": contact,
    "pick_date": pickDate,
    "address_1": address1,
    "contact_1": contact1,
    "pickup_from_time": pickupFromTime,
    "pickup_to_time": pickupToTime,
    "shipment_type": shipmentType,
    "service_type": serviceType,
    "special_instructions": specialInstructions,
    "pickup_time_from_time": pickupTimeFromTime,
    "pickup_time_to_time": pickupTimeToTime,
    "mobile_no": mobileNo,
    "flat_no_building_name": flatNoBuildingName,
    "city_town": cityTown,
    "landmark": landmark,
    "contact_person_number": contactPersonNumber,
    "from_time": fromTime,
    "to_time": toTime,
    "address_dispaly": addressDispaly,
    "assigned_to_driver": assignedToDriver,
    "assigned_to_vehicle": assignedToVehicle,
    "longitude": longitude,
    "latitude": latitude,
    "pickup_longitude": pickupLongitude,
    "pickup_latitude": pickupLatitude,
    "destination_longitude": destinationLongitude,
    "destination_latitude": destinationLatitude,
    "naming_series": namingSeries,
    "lead": lead,
    "enquiry": enquiry,
    "quotation": quotation,
    "sales_order": salesOrder,
    "purchase_order": purchaseOrder,
    "delivery_note": deliveryNote,
    "post_office": postOffice,
    "hub": hub,
    "is_paid": isPaid,
    "mode_pf_payment": modePfPayment,
    "mode_of_payment": modeOfPayment,
    "received_at": receivedAt,
    "post_officehub": postOfficehub,
    "service_partner": servicePartner,
    "document_barcode": documentBarcode,
    "delivered_time": deliveredTime,
    "validation": validation,
    "postal_code": postalCode,
  };
}

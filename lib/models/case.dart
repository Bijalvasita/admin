class Case {
  String? id;
  final String agreementId;
  final String customerName;
  final double emi;
  final String pos;
  final String paidUnpaid;
  final String flow;
  final String caseStatus;
  final String area;
  final String residenceAddress;
  final String zipCode;
  final String contactNo;
  final DateTime disbDate;
  final DateTime emiStartDate;
  final DateTime emiEndDate;
  final String refName1;
  final String refName2;
  final String salesPoint;
  final String roName;
  final String soName;
  final String manufacturerDesc;
  final String product;
  final String rcDetails;
  final String executiveId;

  Case({
    this.id,
    required this.agreementId,
    required this.customerName,
    required this.emi,
    required this.pos,
    required this.paidUnpaid,
    required this.flow,
    required this.caseStatus,
    required this.area,
    required this.residenceAddress,
    required this.zipCode,
    required this.contactNo,
    required this.disbDate,
    required this.emiStartDate,
    required this.emiEndDate,
    required this.refName1,
    required this.refName2,
    required this.salesPoint,
    required this.roName,
    required this.soName,
    required this.manufacturerDesc,
    required this.product,
    required this.rcDetails,
    this.executiveId = '', // Default value for executiveId
  });

  factory Case.fromCsv(List<dynamic> row, String executiveId) {
    return Case(
      agreementId: row[0].toString(),
      customerName: row[1].toString(),
      emi: double.tryParse(row[2].toString()) ?? 0.0,
      pos: row[3].toString(),
      paidUnpaid: row[4].toString(),
      flow: row[5].toString(),
      caseStatus: row[6].toString(),
      area: row[7].toString(),
      residenceAddress: row[8].toString(),
      zipCode: row[9].toString(),
      contactNo: row[10].toString(),
      disbDate: DateTime.tryParse(row[11].toString()) ?? DateTime(1970),
      emiStartDate: DateTime.tryParse(row[12].toString()) ?? DateTime(1970),
      emiEndDate: DateTime.tryParse(row[13].toString()) ?? DateTime(1970),
      refName1: row[14].toString(),
      refName2: row[15].toString(),
      salesPoint: row[16].toString(),
      roName: row[17].toString(),
      soName: row[18].toString(),
      manufacturerDesc: row[19].toString(),
      product: row[20].toString(),
      rcDetails: row[21].toString(),
      executiveId: executiveId,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'agreementId': agreementId,
      'customerName': customerName,
      'emi': emi,
      'pos': pos,
      'paidUnpaid': paidUnpaid,
      'flow': flow,
      'caseStatus': caseStatus,
      'area': area,
      'residenceAddress': residenceAddress,
      'zipCode': zipCode,
      'contactNo': contactNo,
      'disbDate': disbDate.toIso8601String(),
      'emiStartDate': emiStartDate.toIso8601String(),
      'emiEndDate': emiEndDate.toIso8601String(),
      'refName1': refName1,
      'refName2': refName2,
      'salesPoint': salesPoint,
      'roName': roName,
      'soName': soName,
      'manufacturerDesc': manufacturerDesc,
      'product': product,
      'rcDetails': rcDetails,
      'executiveId': executiveId,
      'id': id,
    };
  }

  // fromJson
  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
        agreementId: json['agreementId'] ?? '',
        customerName: json['customerName'] ?? '',
        emi: (json['emi'] ?? 0.0).toDouble(),
        pos: json['pos'] ?? '',
        paidUnpaid: json['paidUnpaid'] ?? '',
        flow: json['flow'] ?? '',
        caseStatus: json['caseStatus'] ?? '',
        area: json['area'] ?? '',
        residenceAddress: json['residenceAddress'] ?? '',
        zipCode: json['zipCode'] ?? '',
        contactNo: json['contactNo'] ?? '',
        disbDate: DateTime.tryParse(json['disbDate'] ?? '') ?? DateTime(1970),
        emiStartDate:
            DateTime.tryParse(json['emiStartDate'] ?? '') ?? DateTime(1970),
        emiEndDate:
            DateTime.tryParse(json['emiEndDate'] ?? '') ?? DateTime(1970),
        refName1: json['refName1'] ?? '',
        refName2: json['refName2'] ?? '',
        salesPoint: json['salesPoint'] ?? '',
        roName: json['roName'] ?? '',
        soName: json['soName'] ?? '',
        manufacturerDesc: json['manufacturerDesc'] ?? '',
        product: json['product'] ?? '',
        rcDetails: json['rcDetails'] ?? '',
        executiveId: json['executiveId'] ?? '',
        id: json['id']);
  }

  @override
  String toString() {
    return 'Case(agreementId: $agreementId, customerName: $customerName, emi: $emi, pos: $pos, '
        'paidUnpaid: $paidUnpaid, flow: $flow, caseStatus: $caseStatus, area: $area, '
        'residenceAddress: $residenceAddress, zipCode: $zipCode, contactNo: $contactNo, '
        'disbDate: $disbDate, emiStartDate: $emiStartDate, emiEndDate: $emiEndDate, '
        'refName1: $refName1, refName2: $refName2, salesPoint: $salesPoint, roName: $roName, '
        'soName: $soName, manufacturerDesc: $manufacturerDesc, product: $product, rcDetails: $rcDetails)';
  }
}

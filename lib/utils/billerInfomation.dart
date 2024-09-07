// get biller name from biller code
import 'package:bill_payment/utils/mxbillpaylogopath.dart';

BillerModel? getBillerNameFromCode(String billerCode) {
  return {
    'BIL099':
        BillerModel(name: 'MTN Nigeria', path: MxBillPayLogos.aimtnnigeria),
    'BIL100': BillerModel(
        name: 'AIRTEL NIGERIA', path: MxBillPayLogos.aiairtelnigeria),
    'BIL102':
        BillerModel(name: 'GLO NIGERIA', path: MxBillPayLogos.aiglonigeria),
    'BIL103': BillerModel(
        name: '9MOBILE NIGERIA', path: MxBillPayLogos.aimobile9nigeria),
    // ughanda
    'BIL153': BillerModel(name: 'MTN', path: MxBillPayLogos.aimtnouganda),
    'BIL154': BillerModel(name: 'AIRTEL', path: MxBillPayLogos.aiairteluganda),
    'BIL155':
        BillerModel(name: 'AFRICELL', path: MxBillPayLogos.aiafricelluganda),
    'BIL132': BillerModel(name: 'MTN VTU', path: MxBillPayLogos.aimtnouganda),
    'BIL133': BillerModel(name: 'TIGO VTU', path: MxBillPayLogos.aitigouganda),
    'BIL134': BillerModel(
        name: 'VODAFONE VTU', path: MxBillPayLogos.aivodaphoneuganda),
    'BIL140': BillerModel(
        name: 'VODAFONE POSTPAID PAYMENT',
        path: MxBillPayLogos.aivodaphoneuganda),
    //end
    'BIL187': BillerModel(name: 'AIRTEL', path: MxBillPayLogos.aiairtelkenya),
    'BIL188':
        BillerModel(name: 'SAFARICOM', path: MxBillPayLogos.aisafaricomkenya),
    'BIL189': BillerModel(name: 'TELKOM', path: MxBillPayLogos.aitelkomkenya),
    'BIL196':
        BillerModel(name: 'AIRTEL ZM', path: MxBillPayLogos.aiairtelzambia),
    'BIL197': BillerModel(name: 'MTN ZM', path: MxBillPayLogos.aimtnzambia),
    'BIL198':
        BillerModel(name: 'VODAFONE ZM', path: MxBillPayLogos.aivodafonezambia),
    'BIL199':
        BillerModel(name: 'ZAMTEL ZM', path: MxBillPayLogos.aizemtelzambia),
    'BIL135': BillerModel(name: 'T-MOBILE', path: MxBillPayLogos.aitmobileus),

    // toll
    'BIL131': BillerModel(
        name: 'DHL shipping payments', path: MxBillPayLogos.lccpnigeria),
    // cables
    'BIL121': BillerModel(name: 'DSTV', path: MxBillPayLogos.cadstvnigeria),
    'BIL122': BillerModel(name: 'GOTV', path: MxBillPayLogos.cagotvnigeria),
    'BIL123':
        BillerModel(name: 'STARTIMES', path: MxBillPayLogos.castarnigeria),
    'BIL001': BillerModel(name: 'Starter Basic Plan', path: ''),
    'BIL156':
        BillerModel(name: 'DSTV UGANDA', path: MxBillPayLogos.cadstvuganda),
    'BIL157':
        BillerModel(name: 'GOTV UGANDA', path: MxBillPayLogos.cagotvuganda),
    'BIL160': BillerModel(
        name: 'STARTIMES UGANDA', path: MxBillPayLogos.castaruganda),
    'BIL190': BillerModel(name: 'DSTV KE', path: MxBillPayLogos.cadstvkenya),
    'BIL192': BillerModel(name: 'GOTV KE', path: MxBillPayLogos.cagotvkenya),
    'BIL193': BillerModel(
        name: 'STARTIMES KE', path: MxBillPayLogos.castartimeskenya),
    'BIL137': BillerModel(name: 'DSTV GHANA', path: MxBillPayLogos.cadstvghana),
    'BIL138': BillerModel(name: 'GOTV GHANA', path: MxBillPayLogos.cagotvghana),
    'BIL200': BillerModel(name: 'DSTV ZM', path: MxBillPayLogos.cadstvuzambia),
    'BIL201': BillerModel(name: 'GOTV ZM', path: MxBillPayLogos.cagotvuzambia),

    // internet services
    'BIL125': BillerModel(
        name: 'SPECTRANET LIMITED', path: MxBillPayLogos.inspectranetnigeria),
    'BIL126':
        BillerModel(name: 'SWIFT 4G', path: MxBillPayLogos.inswift4gnigeria),
    'BIL129': BillerModel(
        name: 'ipNX Subscription Payments', path: MxBillPayLogos.inipnxnigeria),
    'BIL136':
        BillerModel(name: 'MTN HYNET', path: MxBillPayLogos.inmtnhynetnigeria),
    'BIL124': BillerModel(name: 'SMILE', path: MxBillPayLogos.insmilenigeria),
    'BIL139': BillerModel(
        name: 'VODAFONE BROADBAND(ADSL)', path: MxBillPayLogos.invodafoneghana),
    'BIL141':
        BillerModel(name: 'SURFLINE', path: MxBillPayLogos.insurflineghana),
    // mobile data
    'BIL108':
        BillerModel(name: 'MTN DATA BUNDLE', path: MxBillPayLogos.dbmtnnigeria),
    'BIL109':
        BillerModel(name: 'GLO DATA BUNDLE', path: MxBillPayLogos.dbglonigeria),
    'BIL110': BillerModel(
        name: 'AIRTEL DATA BUNDLE', path: MxBillPayLogos.dbairtelnigeria),
    'BIL111': BillerModel(
        name: '9MOBILE DATA BUNDLE', path: MxBillPayLogos.dbmobile9nigeria),
    'BIL161': BillerModel(
        name: 'AFRICELL UG Data Bundle', path: MxBillPayLogos.dbafricelluganda),
    'BIL162': BillerModel(
        name: 'MTN UG DATA BUNDLE', path: MxBillPayLogos.dbmtnuganda),
    'BIL163': BillerModel(
        name: 'AIRTEL UG DATA BUNDLE', path: MxBillPayLogos.dbairteluganda),

    // electricity
    'BIL112': BillerModel(
        name: 'EKO DISCO ELECTRICITY BILLS', path: MxBillPayLogos.elekonigeria),
    'BIL113': BillerModel(
        name: 'IKEJA DISCO ELECTRICITY BILLS',
        path: MxBillPayLogos.elikejanigeria),
    'BIL114': BillerModel(
        name: 'IBADAN DISCO ELECTRICITY BILLS',
        path: MxBillPayLogos.elibadannigeria),
    'BIL115': BillerModel(
        name: 'ENUGU DISCO ELECTRICITY BILLS',
        path: MxBillPayLogos.elenugunigeria),
    'BIL116': BillerModel(
        name: 'PORT HARCOURT DISCO ELECTRICITY BILLS',
        path: MxBillPayLogos.elporthacnigeria),
    'BIL117': BillerModel(
        name: 'BENIN DISCO ELECTRICITY BILLS',
        path: MxBillPayLogos.elbeninnigeria),
    'BIL118': BillerModel(
        name: 'YOLA DISCO ELECTRICITY BILLS',
        path: MxBillPayLogos.elyolanigeria),
    'BIL119': BillerModel(
        name: 'KADUNA DISCO ELECTRICITY BILLS',
        path: MxBillPayLogos.elkadunanigeria),
    'BIL120': BillerModel(
        name: 'KANO DISCO ELECTRICITY BILLS',
        path: MxBillPayLogos.elkanonigeria),
    'BIL127': BillerModel(
        name: 'Lekki Concession Company Payment',
        path: MxBillPayLogos.lccpnigeria),
    'BIL204':
        BillerModel(name: 'ABUJA DISCO', path: MxBillPayLogos.elabudisnigeria),
    'BIL191':
        BillerModel(name: 'KPLC Electricity', path: MxBillPayLogos.elkplckenya),
    'BIL194': BillerModel(
        name: 'NAIROBI WATER', path: MxBillPayLogos.elabudisnigeria),
    'BIL142': BillerModel(
        name: 'Electricity Company of Ghana', path: MxBillPayLogos.elecogghana),
    'BIL158':
        BillerModel(name: 'Umeme Payment', path: MxBillPayLogos.elumemeuganda),
    'BIL159': BillerModel(
        name: 'National Water Service Corporation Payment',
        path: MxBillPayLogos.elabudisnigeria),
    'BIL202': BillerModel(name: 'ZESCO', path: MxBillPayLogos.elzescouganda),
    'BIL203': BillerModel(
        name: 'ZUKU DEFAULT BUCKET', path: MxBillPayLogos.elzescouganda),
  }[billerCode];
}

String? getBillerCodeFromName(String billerName) {
  return {
    'MTN Nigeria': 'BIL099',
    'AIRTEL NIGERIA': 'BIL100',
    'GLO NIGERIA': 'BIL102',
    '9MOBILE NIGERIA': 'BIL103',
    'MTN': 'BIL153',
    'AIRTEL': 'BIL154',
    'AFRICELL': 'BIL155',
    'MTN VTU': 'BIL132',
    'TIGO VTU': 'BIL133',
    'VODAFONE VTU': 'BIL134',
    'VODAFONE POSTPAID PAYMENT': 'BIL140',
    'AIRTEL KENYA': 'BIL187',
    'SAFARICOM KENYA': 'BIL188',
    'TELKOM KENYA': 'BIL189',
    'AIRTEL ZM': 'BIL196',
    'MTN ZM': 'BIL197',
    'VODAFONE ZM': 'BIL198',
    'ZAMTEL ZM': 'BIL199',
    'T-MOBILE': 'BIL135',
    'DHL shipping payments': 'BIL131',
    'DSTV': 'BIL121',
    'GOTV': 'BIL122',
    'STARTIMES': 'BIL123',
    'DSTV UGANDA': 'BIL156',
    'GOTV UGANDA': 'BIL157',
    'STARTIMES UGANDA': 'BIL160',
    'DSTV KE': 'BIL190',
    'GOTV KE': 'BIL192',
    'STARTIMES KE': 'BIL193',
    'DSTV GHANA': 'BIL137',
    'GOTV GHANA': 'BIL138',
    'DSTV ZM': 'BIL200',
    'GOTV ZM': 'BIL201',
    'SPECTRANET LIMITED': 'BIL125',
    'SWIFT 4G': 'BIL126',
    'ipNX Subscription Payments': 'BIL129',
    'MTN HYNET': 'BIL136',
    'SMILE': 'BIL124',
    'VODAFONE BROADBAND(ADSL)': 'BIL139',
    'SURFLINE': 'BIL141',
    'MTN DATA BUNDLE': 'BIL108',
    'GLO DATA BUNDLE': 'BIL109',
    'AIRTEL DATA BUNDLE': 'BIL110',
    '9MOBILE DATA BUNDLE': 'BIL111',
    'AFRICELL UG Data Bundle': 'BIL161',
    'MTN UG DATA BUNDLE': 'BIL162',
    'AIRTEL UG DATA BUNDLE': 'BIL163',
    'EKO DISCO ELECTRICITY BILLS': 'BIL112',
    'IKEJA DISCO ELECTRICITY BILLS': 'BIL113',
    'IBADAN DISCO ELECTRICITY BILLS': 'BIL114',
    'ENUGU DISCO ELECTRICITY BILLS': 'BIL115',
    'PORT HARCOURT DISCO ELECTRICITY BILLS': 'BIL116',
    'BENIN DISCO ELECTRICITY BILLS': 'BIL117',
    'YOLA DISCO ELECTRICITY BILLS': 'BIL118',
    'KADUNA DISCO ELECTRICITY BILLS': 'BIL119',
    'KANO DISCO ELECTRICITY BILLS': 'BIL120',
    'Lekki Concession Company Payment': 'BIL127',
    'ABUJA DISCO': 'BIL204',
    'KPLC Electricity': 'BIL191',
    'NAIROBI WATER': 'BIL194',
    'Electricity Company of Ghana': 'BIL142',
    'Umeme Payment': 'BIL158',
    'National Water Service Corporation Payment': 'BIL159',
    'ZESCO': 'BIL202',
    'ZUKU DEFAULT BUCKET': 'BIL203',
  }[billerName];
}

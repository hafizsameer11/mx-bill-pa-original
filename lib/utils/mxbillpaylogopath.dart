class MxBillPayLogos {
  static const _baspath = 'assets/Mx Bill Pay SVG Logos';

  static const _airtime = '$_baspath/Airtime';
  static const _cables = '$_baspath/Cables';
  static const _databundle = '$_baspath/Data Bundle';
  static const _internet = '$_baspath/Internet';
  static const _power = '$_baspath/Power';
  static const _toll = '$_baspath/Toll';

  // ----------- air time -----------
  static const _airtimeghana = '$_airtime/Ghana';
  static const _airtimekenya = '$_airtime/Kenya';
  static const _airtimenigeria = '$_airtime/Nigeria';
  static const _airtimeuganda = '$_airtime/Uganda';
  static const _airtimeunitedstates = '$_airtime/United States';
  static const _airtimezambia = '$_airtime/Zambia';
  // ----------- cables -----------
  static const _cableghana = '$_cables/Ghana';
  static const _cablekenya = '$_cables/Kenya';
  static const _cablezambia = '$_cables/Zambia';
  static const _cablenigeria = '$_cables/Nigeria';
  static const _cableuganda = '$_cables/Uganda';
  // ----------- databundle -----------
  static const _databundlenigeria = '$_databundle/Nigeria';
  static const _databundleuganda = '$_databundle/Uganda';
  // ----------- internet -----------
  static const _internetnigeria = '$_internet/Nigeria';
  static const _internetghana = '$_internet/Ghana';
  // ----------- power -----------
  static const _powerghana = '$_power/Ghana';
  static const _powerkenya = '$_power/Kenya';
  static const _powerzambia = '$_power/Zambia';
  static const _powernigeria = '$_power/Nigeria';
  static const _poweruganda = '$_power/Uganda';
  // ----------- toll -----------
  static const _tollnigeria = '$_toll/Nigeria';

  static const aimtnghana = '$_airtimeghana/mtn.svg';
  static const aitigoghana = '$_airtimeghana/tigo.svg';
  static const aivodaphoneghana = '$_airtimeghana/vodafone.svg';
  static const aiairtelkenya = '$_airtimekenya/airtel.svg';
  static const aisafaricomkenya = '$_airtimekenya/safaricom.svg';
  static const aitelkomkenya = '$_airtimekenya/telkom.svg';
  static const aimobile9nigeria = '$_airtimenigeria/9mobile.svg';
  static const aiairtelnigeria = '$_airtimenigeria/airtel.svg';
  static const aiglonigeria = '$_airtimenigeria/glo.svg';
  static const aimtnnigeria = '$_airtimenigeria/mtn.svg';
  static const aiafricelluganda = '$_airtimeuganda/africell.svg';
  static const aitigouganda = '$_airtimeuganda/tigo.svg';
  static const aimtnouganda = '$_airtimeuganda/mtn.svg';
  static const aivodaphoneuganda = '$_airtimeuganda/vodafone.svg';
  static const aiairteluganda = '$_airtimeuganda/airtel.svg';
  static const aitmobileus = '$_airtimeunitedstates/t-mobile.svg';
  static const aiairtelzambia = '$_airtimezambia/airtel.svg';
  static const aimtnzambia = '$_airtimezambia/mtn.svg';
  static const aivodafonezambia = '$_airtimezambia/vodafone.svg';
  static const aizemtelzambia = '$_airtimezambia/zemtel.svg';

  static const cadstvghana = '$_cableghana/dstv.svg';
  static const cagotvghana = '$_cableghana/Gotv.svg';
  static const cadstvkenya = '$_cablekenya/dstv.svg';
  static const cagotvkenya = '$_cablekenya/Gotv.svg';
  static const castartimeskenya = '$_cablekenya/startimes.svg';
  static const cadstvnigeria = '$_cablenigeria/dstv.svg';
  static const cagotvnigeria = '$_cablenigeria/Gotv.svg';
  static const castarnigeria = '$_cablenigeria/startimes.svg';
  static const cadstvuganda = '$_cableuganda/dstv.svg';
  static const cagotvuganda = '$_cableuganda/Gotv.svg';
  static const castaruganda = '$_cableuganda/startimes.svg';
  static const cadstvuzambia = '$_cablezambia/dstv.svg';
  static const cagotvuzambia = '$_cablezambia/Gotv.svg';

  static const dbmobile9nigeria = '$_databundlenigeria/9mobile.svg';
  static const dbairtelnigeria = '$_databundlenigeria/airtel.svg';
  static const dbglonigeria = '$_databundlenigeria/glo.svg';
  static const dbmtnnigeria = '$_databundlenigeria/mtn.svg';
  static const dbafricelluganda = '$_databundleuganda/africell.svg';
  static const dbairteluganda = '$_databundleuganda/airtel.svg';
  static const dbmtnuganda = '$_databundleuganda/mtn (1).svg';

  static const insurflineghana = '$_internetghana/surfline.svg';
  static const invodafoneghana =
      '$_internetghana/vodafone broadband (adsl).svg';
  static const inipnxnigeria = '$_internetnigeria/ipnx.svg';
  static const inmtnhynetnigeria = '$_internetnigeria/mtn hynet.svg';
  static const insmilenigeria = '$_internetnigeria/smile.svg';
  static const inspectranetnigeria = '$_internetnigeria/spectranet.svg';
  static const inswift4gnigeria = '$_internetnigeria/swift 4G.svg';

  static const elecogghana = '$_powerghana/Electricity Company Of Ghana.svg';
  static const elkplckenya = '$_powerkenya/KPLC Electricity.svg';
  static const elabudisnigeria = '$_powernigeria/Abuja Disco.svg';
  static const elbeninnigeria = '$_powernigeria/Benin Disco.svg';
  static const elekonigeria = '$_powernigeria/Eko Disco.svg';
  static const elenugunigeria = '$_powernigeria/Enugu Disco.svg';
  static const elibadannigeria = '$_powernigeria/Ibadan Disco.svg';
  static const elikejanigeria = '$_powernigeria/Ikeja Disco.svg';
  static const elkadunanigeria = '$_powernigeria/Kaduna Disco.svg';
  static const elkanonigeria = '$_powernigeria/kano.svg';
  static const elporthacnigeria = '$_powernigeria/Port Hacourt Disco.svg';
  static const elyolanigeria = '$_powernigeria/Yola Disco.svg';
  static const elumemeuganda = '$_poweruganda/umeme payment.svg';
  static const elzescouganda = '$_powerzambia/Zesco.svg';

  static const lccpnigeria =
      '$_tollnigeria/Lekki Concession Company Payment.svg';
}

class BillerModel {
  final String name, path;

  BillerModel({
    required this.name,
    required this.path,
  });
}

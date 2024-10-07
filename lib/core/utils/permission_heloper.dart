import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      return false;
    }

    return true;
  }

  static Future<bool?> requestLocation() async {
    // التحقق من حالة الإذن الحالي
    var status = await Permission.location.status;

    // إذا كان الإذن غير محدد (مطلوب) أو مرفوض
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.restricted) {
      // طلب الإذن
      status = await Permission.location.request();
    }

    // التحقق من حالة الإذن بعد الطلب
    if (status == PermissionStatus.granted) {
      return true; // الإذن تم منحه
    } else if (status == PermissionStatus.denied) {
      // إذا تم رفض الإذن
      print('تم رفض إذن الموقع.');
      // هنا يمكنك إظهار رسالة للمستخدم بدلاً من فتح الإعدادات
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      // إذا تم رفض الإذن بشكل دائم
      print('تم رفض إذن الموقع بشكل دائم.');
      return false; // لا تفعل شيء أو أظهر رسالة
    } else if (status == PermissionStatus.restricted) {
      // إذا كانت الحالة مقيدة
      print('إذن الموقع مقيد.');
      return false;
    } else if (status == PermissionStatus.limited) {
      // إذا كانت الحالة محدودة (لنظام iOS 14 وما فوق)
      print('إذن الموقع محدود.');
      return true; // يمكنك التعامل مع الوصول المحدود حسب حاجتك
    }

    return false; // قيمة افتراضية
  }
  static Future<bool> checkLocationPermissionStatus() async {
    final status = await Permission.location.status;
    return status.isGranted || status.isLimited;
  }
}

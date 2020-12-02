class ApiUtils {
 static String clientSecret = "uLFGKUMOyJwkUXFo9snUynbPs8C2Ls0OQNFVlOXj";
 static const BaseApiUrl = "https://app.alifpet.com/public/api";
 static const BaseApiUrlForSocket = "ws://app.alifpet.com/public/api";
 static const BaseApiUrlMain = "https://app.alifpet.com/public/storage/";
 static Map<String,dynamic> normalHeader = {
  "Accept": "application/json",
  "Content-Type": "application/json"
 };
 static Map<String,dynamic> headerForRegister = {
  "X-Requested-With": "application/json",
  "Content-Type": "application/x-www-form-urlencoded"
 };
 static Map<String,dynamic> headerWithToken = {
  "X-Requested-With": "application/json",
  "content-type": "application/x-www-form-urlencoded",
  "Authorization" : ""
 };
}
import 'dart:convert';
import 'dart:io';

class SocketUtils {
  Socket _socket;
  static const String SERVER_IP = "52.57.112.216";
  static const int PORT = 6001;

  Future<bool> sendMessage(String message , Function connectionListner) async{
    try{
        _socket = await Socket.connect(SERVER_IP, PORT);
        connectionListner(true);
        _socket.listen((List<int> events) {
          String message = utf8.decode(events);
          print("message : $message");
        });
        _socket.add(utf8.encode(message));
        _socket.close();
    }catch(e){
      connectionListner(false);
      return false;
    }
    return true;
  }
  void cleanUp(){
    if(_socket!=null){
      _socket.destroy();
    }
  }
}
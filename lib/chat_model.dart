class ChatModel {
  String type;
  String body;

  ChatModel.fromUser(this.body) : type = "user";

  ChatModel.fromModal(this.body) : type = "modal";
}

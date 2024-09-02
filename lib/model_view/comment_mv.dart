class CommentMv {
  List get comments => [];

  get(String commentId) {}

  add(String type, String subjectId, String comment) {}

  remove(String commentId) {}

  update(String commentId, String comment) {}

  count(String type, String subjectId) {}

  enswer(String parentCommentId, String newComment) {}
}

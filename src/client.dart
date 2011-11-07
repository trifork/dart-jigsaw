#library('jigsaw.client.dart');

//Dart libs
#import('../dlib/html/html.dart');
#import('../dlib/base/base.dart');

//dlibs
#import('../dlib/events_base.dart', prefix: "e");
#import('../dlib/pprint.dart', prefix: "pprint");
#import('../dlib/utils.dart');

//model
#import('shared/model.dart');


#source('client/Jigsaw.dart');
#source('client/view/JigsawView.dart');
#source('client/view/PuzzleView.dart');
#source('client/controller/JigsawController.dart');

main() {
  Jigsaw.main();
}

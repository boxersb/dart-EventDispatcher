import "../src/EventDispatcher.dart";
import "dart:html";

class SampleModel extends EventDispatcher {
  
}

class SampleView extends EventDispatcher {

}

class SampleController {
	SampleModel _model;
	
	SampleView _view;

	SampleController(this._model, this._view) {
		_attachEvent();
	}

	_attachEvent() {

	}
}


main() {
  
}
library EventDispatcher;

typedef void Handler(CustomEvent e);

class CustomEvent {
  String _eventType = "none";
  Map _event = {};

  String get type => _eventType;
  set type(String _type) => _eventType = _type;

  CustomEvent(this._eventType, [this._event]);

  void setProperty(String propertyName, propertyValue) {
    _event[propertyName] = propertyValue;
  }

  getProperty(String propertyName) => _event[propertyName];
}

class EventListenerHash {
  Map <String, List>_hash = <String, List>{};

  void add(String type, Handler hnd) {
    List listeners = getListenersByType(type);

    listeners.add(hnd);
  }

  void remove(String type, [Handler hnd]) {
    if(!hasType(type)) return;

    if(?hnd){
      List listeners = getListenersByType(type);
      int idx = listeners.indexOf(hnd);

      if(idx > -1){
        listeners.removeAt(idx);
      }
    }else{
      _hash[type] = null;
    }
  }

  bool hasType(String type) {
    return (_hash[type] != null && _hash is List && _hash.length > 0);
  }

  List getListenersByType(String type) {
    if(!_hash.containsKey(type)) {
      _hash[type] = [];
    }

    return _hash[type];
  }
}

class EventDispatcher {
  EventListenerHash _hash = new EventListenerHash();
  
  void attach(type, [Handler hnd]) {
    if(?hnd){
      type = type as String;
      _hash.add(type, hnd);
    }else{
      Map <String, Handler>listenerList = type as Map;
      
      listenerList.forEach( (String key, Handler hnd) => attach(key, hnd) );
    }
  }
  
  void detach(type, [Handler hnd]) {
    if(?hnd){
      type = type as String;
      _hash.remove(type, hnd);
    }else if(type is String){
      _hash.remove(type);
    }else if(type is Map){
      Map <String, Handler>listenerList = type as Map;
      
      listenerList.forEach( (String key, Handler hnd) => detach(key, hnd) );
    }
  }
  
  bool dispatch(CustomEvent e) {
    String type = e.type;

    if(!_hash.hasType(type)) return false;
    
    List listeners = _hash.getListenersByType(type);
    
    listeners.forEach((Handler f) {
      f(e);
    });
    
    return true;
  }
}

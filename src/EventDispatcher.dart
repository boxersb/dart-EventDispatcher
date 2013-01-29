library EventDispatcher;

typedef void Handler(CustomEvent e);

class CustomEvent {
  String _eventType = "none";
  Map _detail = {};

  String get type => _eventType;
  set type(String _type) => _eventType = _type;
  
  Map get detail => _detail;

  CustomEvent(this._eventType, [this._detail]);

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

      print(type);
      print(idx);
      print(listeners.length);
      if(idx > -1){
        listeners.removeAt(idx);
      }
    }else{
      _hash[type] = null;
    }
  }

  bool hasType(String type) {
    List hashOfType = _hash[type];
    
    return (hashOfType != null && hashOfType is List && hashOfType.length > 0);
  }

  List getListenersByType(String type) {
    if(!_hash.containsKey(type)) {
      _hash[type] = [];
    }

    return _hash[type];
  }
}

class EventListener {
  String type;
  Handler handler;
  
  EventListener(this.type, this.handler);
}

class EventDispatcher {
  EventListenerHash _hash = new EventListenerHash();
  
  void operator +(EventListener listener) {
    return attach(listener.type, listener.handler);
  }
  
  void operator -(EventListener listener) {
    return detach(listener.type, listener.handler);
  }
  
  void attach(type, [Handler hnd]) {
    if(?hnd){
      type = type as String;
      _hash.add(type, hnd);        
    } else if(type is EventListener) {
      EventListener listener = type as EventListener;
      _hash.add(listener.type, listener.handler);
    } else {
      Map <String, Handler>listenerList = type as Map;
      
      listenerList.forEach( (String key, Handler hnd) => attach(key, hnd) );
    }
  }
  
  void detach(type, [Handler hnd]) {
    if(?hnd){
      type = type as String;
      _hash.remove(type, hnd);
    } else if(type is EventListener) {
      EventListener listener = type as EventListener;
      _hash.remove(listener.type, listener.handler);
    } else if(type is String) {
      _hash.remove(type);
    } else if(type is Map) {
      Map <String, Handler>listenerList = type as Map;
      
      listenerList.forEach( (String key, Handler hnd) => detach(key, hnd) );
    }
  }
  
  void dispatch(e, [Map detail]) {
    CustomEvent event = (e is CustomEvent) ? e as CustomEvent : new CustomEvent(e as String, detail);
 
    String type = event.type;
    if(!_hash.hasType(type)) return;
    
    List listeners = _hash.getListenersByType(type);
    
    listeners.forEach((Handler f) {
      f(event);
    });
  }
}

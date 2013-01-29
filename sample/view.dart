part of VendingMachine;

class View extends Sample.EventDispatcher {
	Element _wrapper;
	List<Product> _products = [
		new Product(699, "./images/iphone5.png"),
		new Product(799, "./images/note2.png"),
		new Product(659, "./images/optimus-g.png"),
		new Product(399, "./images/nexus4.png")
	];

	View() {
		_wrapper = query("ul.item-list");
	}

	void draw() {
		_products.forEach((Product p) {
			_wrapper.nodes.add(p.element);
			
			p.attach({
			  "buy" : _onBuy,
			  "sell" : _onSell
			});
		});
		
		query("a.stop").on.click.add((e) {
		  print(e);
		  dispatch("clickStop");
		});
	}
	
	void suspend() {
	  _products.forEach((Product p) {
      p.detach({
        "buy" : _onBuy,
        "sell" : _onSell
      });
    });
	}

	void _onBuy(Sample.CustomEvent e) {
		dispatch(e);
	}

	void _onSell(Sample.CustomEvent e) {
		dispatch(e);
	}
  
  void changeAmount(num amount) {
    query("span.balance em").text = amount.toString();
  }
}

class Product extends Sample.EventDispatcher {
	String _thumbUrl = "data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH+A1BTQQAsAAAAAAEAAQAAAgJEAQA7";
	int price = 0;
	String _baseTemplate = "";

	Element _el;
	Element get element => _el;
	set element(Element e) => _el = e;

	AnchorElement buy;
	AnchorElement sell;

	Product(this.price, this._thumbUrl) {
	  _baseTemplate = """
	      <li>
	          <span class="item">
	            <img src="${this._thumbUrl}" alt="iPhone 5" />
	          </span>
	          <span class="price">\$${this.price}</span>
	  
	          <a href="#" class="buy">Buy</a>
	          <a href="#" class="sell">Sell</a>    
	        </li>
	    """;

		_prepareDOM();
		_bindEvents();
	}

	void _prepareDOM() {
		element = new Element.html(_baseTemplate);
		buy = element.query("a.buy");
		sell = element.query("a.sell");
	}

	void _bindEvents() {
		buy.on.click.add((e) {
//		  print(e);
			dispatch(new Sample.CustomEvent("buy", {
				"product": this
			}));
		});

		sell.on.click.add((e) {
			dispatch(new Sample.CustomEvent("sell", {
				"product": this
			}));
		});
	}
}
package eyedrink;

import brix.component.ui.DisplayObject;
import brix.util.DomTools;
import js.Lib;
import js.Dom;

enum ElementType {
	quantity;
	container;
	alcohol;
	soft;
}
class ApplicationController extends DisplayObject{
	/**
	 * element type of the element being deited, e.g. the quantity
	 */
	private var elementBeingEdited : ElementType = null;
	/**
	 * constructor
	 */
	private function new(rootElement : HtmlDom, brixId:String) 
	{
		super(rootElement, brixId);
		rootElement.addEventListener("click", onClick, true);
		initElementsBg();
	}
	/**
	 * init the design
	 */
	private function initElementsBg(){
		var elements = DomTools.getElementsByAttribute(rootElement, "data-item", "*");
		for (elem in elements){
			//trace("init element "+elem);
			var itemName = elem.getAttribute("data-item");
			applyImg(elem, itemName);
		}
	}

	/**
	 * apply an image to the given element
	 */
	private function applyImg(elem:HtmlDom, itemName:String){
		elem.style.background = "url(assets/"+itemName+".png) center center no-repeat";
	}

	/**
	 * the user clicked
	 */
	private function onClick(e:js.Event) 
	{
		var node = e.target;

		// get item name
		var itemName = node.getAttribute("data-item");
		if (itemName == null)
			throw ("no attribute \"data-item\" on the node clicked");

		trace("onClick "+itemName);

		// switch, to determine if we are on the home page or not
		if (node.getAttribute("data-is-home-button")!=null){
			// on the home page
			elementBeingEdited = switch (itemName){
				case "quantity": quantity;
				case "container": container;
				case "alcohol": alcohol;
				case "soft": soft;
			}
			trace("=> "+elementBeingEdited);
		}
		else{
			// user has chosen something
			// apply the image
			haxe.Timer.delay(function (){
				trace(elementBeingEdited);
				var image = DomTools.getElementsByAttribute(rootElement, "data-item", Std.string(elementBeingEdited))[0];
				trace("delay "+image);
				applyImg(image, itemName);
				// reset 
				elementBeingEdited = null;
			}, 10);
		}
	}

	/*
	private function onClick(e:js.Event) 
	{
		var node = e.target;
		trace("onClick "+node.className);
		switch (node.className) {
			case "quantity":
				haxe.Timer.delay(function (){
					var image = DomTools.getSingleElement(rootElement, "home1");
					trace("delay "+image);
					image.setAttribute("src", node.getAttribute("src"));
				}, 10);
		}
	}
	*/
}
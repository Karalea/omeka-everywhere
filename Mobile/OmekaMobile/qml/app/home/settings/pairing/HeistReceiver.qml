import QtQuick 2.5
import "../../../clients"

/*!
  \qmltype HeistReceiver
  Subscribes to iterative heist polling of a specified pairing code
*/
Item {
    id: receiver

    //heist data fields
    property var session: null;
    property var device: null;
    property var items: [];
    property var error: null;

    //pairing code
    property var code;

    //heist data
    property var data;

    //activation state of receiver
    property var register;

    //comparison item list to identify mods
    property var currentItems: []

    //signal invoked on item addition
    signal addItem(var item);

    //signal invoked on item removal
    signal removeItem(var item);


    /*
      Update registered state depending length of code entered by user
    */
    onCodeChanged: {
        register = code && String(code).length === 4;
    }

    /*
      Manages registration for heist data requests
    */
    onRegisterChanged: {
        if(register) {
            Heist.registerReceiver(receiver);
        } else if(Heist.registered(receiver)) {
            Heist.unregisterReceiver(receiver);
            clearFields()
        }
    }

    /*
      Update data fields and report connection/request errors
    */
    onDataChanged: {
        if(data.errors) {
            error = data.errors[0].message;
            clearFields();
        } else if(register) {
            var entry = data[0];
            if(entry) {
                device = entry.device_id;
                session = entry.id;
                items = entry.item_ids;
                updateItems();
            } else {
                error = "Invalid Pairing Code";
            }
        }
    }

    /*
      Evaluates the item list difference to identify additions
    */
    function updateItems() {
        if(!items) return;

        var additions = diff(items, currentItems);
        for(var a in additions) {
            addItem(additions[a]);
        }

        var removals = diff(currentItems, items);
        for(var r in removals) {
            removeItem(removals[r]);
        }

        currentItems = items;
    }

    /*
      Returns an array containing elements present in a1 that are not present in a2
    */
    function diff(a1, a2) {
        if(!a2) {
            return a1;
        }
        var d = [];
        for(var i in a1) {
            if(a2.indexOf(a1[i]) === -1) {
                d.push(a1[i]);
            }
        }
        return d;
    }

    /*
      Clear data fields
    */
    function clearFields() {
        device = null;
        session = null;
        items = [];
        error = null;
    }

}

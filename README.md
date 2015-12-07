# AppExtensionCommunicator

Communicate between app extension and its containing app.


## Usage Example

You must enable app groups for containing app and extension before using `AppExtensionCommunicator`.

1. Make an instance with app group container URL: `AppExtensionCommunicator(containerURL: containerURL)`
2. Deliver message: `communicator.deliverMessage(message: MSG_AS_DICTIONARY, withIdentifier: ID_AS_STRING)`
3. Observe message: `communicator.observeMessageForIdentifier(ID_AS_STRING) { message in
        ...}`

That's all.

Check the example project for a real world usage.

## Creator

* Twitter: [@_cxa](https://twitter.com/_cxa)
* Apps available on the App Store: <http://lazyapps.com>
* PayPal: xianan.chen+paypal 📧 gmail.com, buy me a cup of coffee if you find it's useful for you.

## License

Under the MIT license. See the LICENSE file for more information.
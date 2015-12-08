# AppExtensionCommunicator

Communicate between app extension and its containing app.


## Usage Example

You must enable app groups for containing app and extension before using `AppExtensionCommunicator`.

1. Make an instance with app group container URL: `AppExtensionCommunicator(containerURL: containerURL?)` or `AppExtensionCommunicator(grounpIdentifer: grounpIdentifer)`
2. Deliver message: `communicator.deliverMessageWithIdentifier(identifier: ID, content: DICTIONARY)`
3. Observe message:   `communicator?.observeMessageForIdentifier(ID) { contentDic in ... }`

That's all.

*If you want to deliver message with content, the `containerURL` should not be nil.*

Check the example project for a real world usage.

## Creator

* Twitter: [@_cxa](https://twitter.com/_cxa)
* Apps available on the App Store: <http://lazyapps.com>
* PayPal: xianan.chen+paypal 📧 gmail.com, buy me a cup of coffee if you find it's useful for you.

## License

Under the MIT license. See the LICENSE file for more information.
# AppExtensionCommunicator

Communicate between extension and its containing app.


## Usage Example

You must enable app groups for containing app and extension before using `AppExtensionCommunicator`.

1. Make an instance with app group container URL: `AppExtensionCommunicator(containerURL: containerURL)`
2. Deliver message: `communicator.deliverMessage(message: MSG_AS_DICTIONARY, withIdentifier: ID_AS_STRING)`
3. Observe message: `communicator.observeMessageForIdentifier(ID_AS_STRING) { message in
        ...}`

That's all.

Check the example project for a real world usage.
		
## Creator

* GitHub: <https://github.com/cxa>
* Twitter: [@_cxa](https://twitter.com/_cxa)
* Apps available in App Store: <http://lazyapps.com>

## License

Under the MIT license. See the LICENSE file for more information.
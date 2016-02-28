# Roadmap

This is what's currently in my head while I'm building the initial draft.

These may change through time based on the development and feedback. Consider them an insight on what's being worked on in my head.

As for the timeline, I'd love to have something "working demo" before the release of Rails5

## Alpha

- Explore ReactivityChannel to be all taken care of by the gem (as a rails engine, this should not have to be a manual step)

- Wrap client side objects in a container (this will allow us to build the next phase)

- Include example app somewhere, probably side repository

- Look at react native wrapper (where I believe this will be most useful)

- Js layer namespaced in `Reactivity`

## Beta

- Access management (not every object should be freely available for the client to get)

- Create "write-back" layer (an object could potentially be modified client side and replicated back to the server)

- Explore ability to have async names between client and server (messages_a and messages_b could point to the same messages resource)

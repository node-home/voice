# Voice

Speak with Home.

Basically acts as a router for words.

## Command

A tree of segments that are matched against live recorded audio
and released as triggers

    /commands
        [Command]

        /<uid>
            {
              "uid": "command",
              "name": "Command",
              "parent": Command or None,
              "patterns": []
            }

            {
              "uid": "lights",
              "name": "Command",
              "parent": None,
              "patterns": [
                "lights",
                "light",
                "aura",
                "hue"
              ]
            }

            {
              "uid": "lights.off",
              "name": "Lights Off",
              "parent": "lights",
              "patterns": [
                "off",
                "dark",
                "darkness",
                "dim"
              ]
            }


Phrases

Expressions that Voice can say.
With multiple variations, Voice will pick one at random.
OR Voice will pick one based on circumstances

- weather
  + Isn't it cold outside
  + Isn't it nice and warm here
  + Such nice weather, shouldn't you go outside?
- time
  + (whisper) Wow, home so late, better get to bed!
  + Good to see you so early!
- last checkin
  + Back again?
  + Long time no see!

Build an interface for celebrities to give us phrases!

    /phrases
        [Phrase]

        /<uid>
            {
                "uid": "welcome",
                "name": "Welcome",
                "parameters: [
                    "name",
                ],
                "variations": [
                    "Hello {name}",
                    "Welcome {name}",
                    "Howdy {name}"
                ]
            }

## Feeds

  voice.words

## Triggers

  voice.when <command>

## Actions

  voice.say "A bunch of words"
  voice.say <phrase>


## Feature requests
  wildcard parts

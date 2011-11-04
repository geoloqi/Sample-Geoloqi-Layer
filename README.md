Sample Geoloqi Layer
====================

This is a simple Ruby script for setting up a new Geoloqi layer. It creates places and triggers for 
sending messages to people when they enter the places. 

When people enter the places, they will get a push notification or SMS sent to them, which can 
include a URL as well. They will also see a story with information about the place on their home timeline
when logging in to the website.

You can find more sample code on the Geoloqi Developers website https://developers.geoloqi.com/sample-code

About Geoloqi Layers
====================

Create Places
-------------

Places exist on a layer. You can create places by using the place/create API method.

For the Calagator layer which reminds people of upcoming events nearby, we create a place record corresponding to the venue of the event. The Geoloqi API will not create duplicate places with the same name, so it's safe to run this multiple times for the same venue.

```ruby
  place = geoloqi.post 'place/create', {
    :layer_id => 'ABC',
    :name => event.venue.title,
    :description => event.venue.description + ' ' + event.venue.address + ' ' + event.venue.url,
    :radius => 500,
    :latitude => event.venue.latitude,
    :longitude => event.venue.longitude
  }
```

Create Triggers
---------------

Triggers can do things such as send messages when people enter places. There are other options as well, such as sending messages when users leave, or after they have been at a place for 5 minutes. You can see the full list of options on the trigger/create API documentation page.

For the Calagator layer, we create a trigger at a venue with the message we want to deliver to users.

```ruby
  geoloqi.post 'trigger/create', {
    :place_id => place['place_id'],
    :type => 'message',
    :date_from => date('c', strtotime('-3 hours', strtotime($event->dateStart))),
    :date_to => date('c', strtotime($event->dateStart)),
    :one_time => 1,
    :text => message,
    :url => 'http://calagator.org/events/' + event.id
  }
```
**date_from, date_to:** The trigger is set to be active 3 hours before the start of the event, and expires at the event start time so people won't get notifications of past events.

**one_time:** Setting this to "1" ensures a user will only receive this message the first time they enter the place, and will not receive it if they come back. Set to "0" or leave it out if you want the message to be recurring.

**text:** The text is a sentence we constructed from the event data such as "Are You Smarter than Your Lawyer and Venture Capitalist? at Urban Airship at 11/01 6:30pm". If the text specified is longer than will fit in a push notification or SMS, it will be trimmed automatically.

**url:** The URL is a link to the event on Calagator. If the message is sent via push notification, clicking on the notification will open the web page. If sent via SMS, the link will be appended to the end of the SMS.

Timeline Stories
----------------

When a user picks up the message, it gets added to their timeline on the web, with links to the layer page and place page. The story will also contain a link to the URL provided in the trigger.

![Geoloqi Layer Message](https://developer-site-content.geoloqi.com/wiki/images/thumb/7/75/calagator-timeline-story.png/500px-calagator-timeline-story.png)

License
=======

Copyright (c) 2011, Geoloqi LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided 
that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the 
following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the 
following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.

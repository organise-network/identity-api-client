# identity-api-client

[![Build Status](https://travis-ci.org/controlshift/identity-api-client.svg?branch=master)](https://travis-ci.org/controlshift/identity-api-client)

API Client for 38 Degree's Identity API

## Install

This api client is distributed as a ruby gem.

`gem install identity-api-client`

## Usage

```ruby
identity = IdentityApiClient.new(host: 'id.test.com', api_token: 'abc123')
person = identity.member.details('abc123', load_current_consents: true)
person.first_name 
=> 'Jane'
person.last_name
=> 'Smith'
person.consents.first.public_id
=> 'terms_of_service_1.0'
```

Example of setting up a target list and sending an email

```ruby
identity = IdentityApiClient.new(host: 'id.test.com', api_token: 'abc123')
mailing = identity.mailings.create({name: "My first API mailing"})
mailing.id
=> 1

mailing = identity.mailings.find_by_id(1)
mailing.update({body: "<p>Bla bla</p>", subject: "Hey!"})

action = identity.actions.find_by(name: "My first petition")
action.id
=> 56

rules = {"include":{"condition":"AND","rules":[{"id":"has-taken-action","field":"has-taken-action","type":"string","operator":"in","value":[action.id]}]},"exclude":{"condition":"OR","rules":[{"id":"noone","field":"noone","type":"string","operator":"equal","value":"on"}]}}

search = identity.searches.create({rules: rules})

mailing.send_mailing(search.id)
=> true
```

Example of getting various Employment Data constants:

```ruby
employement_data = client.employment_data.list

employement_data.employment_statuses
 => [{:slug=>"not_set", :label=>"not set"}, {:slug=>"employee", :label=>"Employed"}, {:slug=>"worker", :label=>"Worker"}, ...]

employement_data.approved_workplaces.first
 => #<Hashie::Mash approved=true created_at="2018-11-27T11:07:06.077+00:00" external_id=31 id=3032 industry_id=nil name="Ampersand" never_approve=nil registered_name=nil registration_id=nil similar_approved_workplace_id=nil similar_approved_workplace_name=nil slug="ampersand" updated_at="2021-02-25T11:36:58.756+00:00">
 
 employement_data.approved_industries.first
 => #<Hashie::Mash approved=true created_at="2020-12-17T19:45:57.318+00:00" id=12 member_count=62 name="Education" slug="education" updated_at="2021-06-23T13:53:11.898+01:00">

employement_data.approved_professions.first
 => #<Hashie::Mash approved=true created_at="2021-01-12T11:57:28.049+00:00" id=116 industry_id=nil name="Dummy workplace: Omqsdjzk" slug="dummyworkplace:omqsdjzk" updated_at="2021-02-05T19:41:36.608+00:00"> 
```

Example of getting employment data for a member:

```ruby
member_data = client.member.details(email: 'person@example.com', load_employment: true)

member_data['employment']['status']

member_data['employment']['current_workplace']

member_data['employment']['industries']

member_data['employment']['professions']
```

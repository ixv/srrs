/-  *srrs, publish
/+  *server, *srrs, *srrs-json, default-agent, verb, dbug, publish
/=  index
  /^  $-(json manx)
  /:  /===/app/srrs/index  /!noun/
::
/=  tile-js
  /^  octs
  /;  as-octs:mimes:html
  /:  /===/app/srrs/js/tile
  /|  /js/
      /~  ~
  ==
/=  js
  /^  octs
  /;  as-octs:mimes:html
  /|  /:  /===/app/srrs/js/index  /js/ 
      /~  ~
  ==
/=  css
  /^  octs
  /;  as-octs:mimes:html
  /:  /===/app/srrs/css/index
  /|  /css/
      /~  ~
  ==
/=  images
  /^  (map knot @)
  /:  /===/app/srrs/img  /_  /png/
::
|%
+$  versioned-state
  $%  [%0 state-zero]
  ==
::
+$  state-zero
  $:  pubs=(map @tas stack)
      paths=(list path)
      subs=(map [ship @tas] stack)
      review=(set [who=ship stack=@tas item=@tas])
  ==
::
+$  card  card:agent:gall
::
--
::
=|  versioned-state
=*  state  -
^-  agent:gall
%-  agent:dbug
%+  verb  |
=<
  |_  bol=bowl:gall
  +*  this       .
      srrs-core  +>
      sc         ~(. srrs-core bol)
      def        ~(. (default-agent this %|) bol)
  ::
  ++  on-init
    :_  this
    =/  rav  [%sing %t [%da now.bol] /app/srrs]
    :~  [%pass /bind/srrs %arvo %e %connect [~ /'~srrs'] %srrs]
        :*  %pass  /launch/srrs  %agent  [our.bol %launch]  %poke
             %launch-action  !>([%add %srrs /srrstile '/~srrs/tile.js'])
        ==
        [%pass /read/paths %arvo %c %warp our.bol q.byk.bol `rav]
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    =^  cards  state
      ?+    mark  (on-poke:def mark vase)
          %noun
        (poke-noun:sc !<(* vase))
          %sign-arvo
        (poke-sign-arvo:sc !<(sign-arvo vase))
          %srrs-action
        (poke-srrs-action:sc !<(action vase))
          %handle-http-request
        =+  !<([eyre-id=@ta =inbound-request:eyre] vase)
        :_  state
        %+  give-simple-payload:app  eyre-id
        %+  require-authorization:app  inbound-request
        poke-handle-http-request:sc
      ==
    [cards this]
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    =^  cards  state
      ?+  path  [~ state]
        [%srrstile *]       (peer-srrstile:sc t.path)
        [%srrs-primary *]   (peer-srrs-primary:sc t.path)
        [%http-response *]  [~ state]
      ==
    [cards this]
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card _this)
    ?+    -.sign  (on-agent:def wire sign)
        %kick
      ?.  ?=([%stack *] wire)
        (on-agent:def wire sign)
      [~ this]
    ::
        %fact
      ?.  ?=(%stack-rumor p.cage.sign)
        (on-agent:def wire sign)
      [~ this]
    ==
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card _this)
    =^  cards  state
      ?+  wire  [~ state]
        [%bind ~]  [~ state]
        [%review-schedule @ ~]  (wake:sc wire)
        [%review-schedule @ @ @ ~]  (wake:sc wire)
      ==
    [cards this]
  ::
  ++  on-save  !>(state)
  ++  on-load
    |=  old=vase
    ^-  (quip card _this)
    =/  old-state=(each versioned-state tang)
      (mule |.(!<(versioned-state old)))
    ?:  ?=(%& -.old-state)
      ~!  p.old-state
      [~ this(state p.old-state)]
    [~ this]
  ++  on-leave  on-leave:def
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?+  path  (on-peek:def path)
        [%x %review ~]        ``noun+!>(review.state)
        [%x %all ~]        ``noun+!>(pubs.state)
        [%x %stacks *]
      ?~  t.t.path
        ~
      ``noun+!>((~(get by pubs.state) `@tas`i.t.t.path))
    ==
  ++  on-fail   on-fail:def
  --
::
|_  bol=bowl:gall
::

++  poke-sign-arvo
  |=  =sign-arvo
  ^-  (quip card _state)
  ~&  arvo+sign-arvo
  [~ state]
::
++  poke-handle-http-request
  |=  =inbound-request:eyre
  ^-  simple-payload:http
  =+  request-line=(parse-request-line url.request.inbound-request)
  ?+  request-line
    not-found:gen
  ::  images
  ::
      [[[~ %png] [%'~srrs' @t ~]] ~]
    =/  filename=@t  i.t.site.request-line
    =/  img=(unit @t)  (~(get by images) filename)
    ?~  img
      not-found:gen
    (png-response:gen (as-octs:mimes:html u.img))
  ::  styling
  ::
      [[[~ %css] [%'~srrs' %index ~]] ~]
    (css-response:gen css)
  ::  scripting
  ::
      [[[~ %js] [%'~srrs' %index ~]] ~]
    (js-response:gen js)
  ::  tile js
  ::
      [[[~ %js] [%'~srrs' %tile ~]] ~]
    (js-response:gen tile-js)
  ::  send review state as json
  ::
      [[[~ %json] [%'~srrs' %update-review ~]] ~]
    %-  json-response:gen
    %-  json-to-octs
    :-  %a
    %+  turn
      ~(tap in review.state)
    update-to-json
  ::  learned status as json for given stack
      [[[~ %json] [%'~srrs' %learn @ ~]] ~]
    =/  stack-name  i.t.t.site.request-line
    %-  json-response:gen
    %-  json-to-octs
    %-  stack-status-to-json  (~(got by pubs) stack-name)
  ::  learned status as json for given stack and item
      [[[~ %json] [%'~srrs' %learn @ @ ~]] ~]
    =/  stack-name  i.t.t.site.request-line
    =/  item-name  i.t.t.t.site.request-line
    =/  =stack  (~(got by pubs) stack-name)
    =/  =item  (~(got by items.stack) item-name)
    %-  json-response:gen
    %-  json-to-octs
    %-  status-to-json  learn.item
  ::  home page; redirect
  ::
      [[~ [%'~srrs' ~]] ~]
    =/  hym=manx  (index (state-to-json state))
    (redirect:gen '/~srrs/review')
  ::  review page
  ::
      [[~ [%'~srrs' %review ~]] ~]
    =/  hym=manx  (index (state-to-json state))

    (manx-response:gen hym)
  ::  subscriptions
  ::
      [[~ [%'~srrs' %subs ~]] ~]
    =/  hym=manx  (index (state-to-json state))
    (manx-response:gen hym)
  ::  created
  ::
      [[~ [%'~srrs' %pubs ~]] ~]
    =/  hym=manx  (index (state-to-json state))
    (manx-response:gen hym)
  ::  new item
  ::
      [[~ [%'~srrs' %new-item ~]] ~]
    =/  hym=manx  (index (state-to-json state))
    (manx-response:gen hym)
  ::  new stack
  ::
      [[~ [%'~srrs' %new-stack ~]] ~]
    =/  hym=manx  (index (state-to-json state))
    (manx-response:gen hym)
  ::  stack
  ::
      [[~ [%'~srrs' @t @t ~]] ~]
    =/  hym=manx  (index (state-to-json state))
    (manx-response:gen hym)
  ::  stack item
  ::
      [[~ [%'~srrs' @t @t @t ~]] ~]
    =/  hym=manx  (index (state-to-json state))
    (manx-response:gen hym)
  ::
  ==
::
++  poke-srrs-action
  |=  act=action
  ^-  (quip card _state)
  ?-  -.act
      %new-stack
    ?.  =(our.bol src.bol)
      [~ state]
    ?:  ?&((~(has by pubs) name.act) =(items.act ~))
      [~ state]
    ::
    =/  conf=stack-info
      :*  our.bol
          title.act
          name.act
          edit.act
          now.bol
          now.bol
      ==
    =^  cards  state  (add-stack conf items.act)
    [cards state]
      %new-item
    =/  front-matter=(map knot cord)
      %-  my
      :~  title+name.act
          author+(scot %p src.bol)
          date-created+(scot %da now.bol)
          last-modified+(scot %da now.bol)
      ==
    =/  front  (add-front-matter front-matter front.act)
    =/  back  (add-front-matter front-matter back.act)
    =/  new-note=content
      :*  src.bol
          title.act
          name.act
          now.bol
          now.bol
          %.y
          front
          back
          (form-snippet front)
          ~
          %.n
      ==
    =/  new-item  (item new-note (learned-status [.2.5 0 0]))
    =/  old-stack=stack  (~(got by pubs) stak.act)
    =/  new-stack=stack
    %=  old-stack
      items  (~(uni by items.old-stack) (my ~[[name.act new-item]]))
    ==
    =/  del  [%add-item our.bol stak.act name.act new-item]
    =/  mov=card  [%give %fact ~[/srrs-primary] %srrs-primary-delta !>(del)]

    [~[mov] state(pubs (~(put by pubs) stak.act new-stack))]
    ::
      %delete-stack
    ~&  delete-stack+act
    :-  ~
    %=  state
      pubs  (~(del by pubs) stak.act)
    ==
      %delete-item
    ~&  delete-item+act
    =/  old-stack=stack  (~(got by pubs) stak.act)
    =/  new-stack=stack
    %=  old-stack
      items  (~(del by items.old-stack) item.act)
    ==
    :-  ~
    %=  state
      review  (~(del in review.state) [our.bol stak.act item.act])
      pubs  (~(put by pubs.state) stak.act new-stack)
    ==
      %edit-stack
    ~&  edit-stack+act
    [~ state]
      %edit-item
    ~&  edit-item+act
    =/  stack  (~(got by pubs) stak.act)
    =/  item=item  (~(got by items.stack) name.act)
    =/  front-matter=(map knot cord)
    %-  my
    :~  title+title.act
        author+(scot %p src.bol)
        date-created+(scot %da date-created.content.item)
        last-modified+(scot %da now.bol)
    ==
    =/  front  (add-front-matter front-matter front.act)
    =/  back  (add-front-matter front-matter back.act)
    =/  new-content  content.item(front front, back back, snippet (form-snippet front), title title.act)
    =/  new-item  item(content new-content)
    =/  new-stack
    %=  stack
      items  (~(put by items.stack) name.act new-item)
    ==
    =/  del  [%add-item our.bol stak.act name.act new-item]
    =/  mov=card  [%give %fact ~[/srrs-primary] %srrs-primary-delta !>(del)]
    :-  ~[mov]
    %=  state
      pubs  (~(put by pubs.state) stak.act new-stack)
    ==
      %schedule-item
    ~&  schedule-item+act
    [~ state]
      %raise-item
    =/  raise  [%add-raised-item our.bol stak.act item.act]
    =/  raise-card=card  [%give %fact ~[/srrs-primary] %srrs-primary-delta !>(raise)]
    :-  (snoc make-tile-moves raise-card)
    %=  state
      review  (~(put in review.state) [our.bol stak.act item.act])
    ==
      %add-books
    =^  cards  state  (add-books books.act)
    [cards state]
      %answered-item
    ~&  answered-item+act
    =/  del  [our.bol stak.act item.act]
    =/  primary-card
      :*  %give
          %fact
          ~[/srrs-primary]
          %srrs-primary-delta
          !>(delete-review-item+del)
      ==
    =^  cards  state  (update-learned-status stak.act item.act answer.act)
    :-  (flop (snoc (weld make-tile-moves cards) primary-card))
    %=  state
      review  (~(del in review.state) [our.bol stak.act item.act])
    ==
      %read
    ~&  read+act
    [~ state]
      %update-review
    [make-tile-moves state]
  ==
::
++  peer-srrstile
  |=  wir=wire
  ^-  (quip card _state)
  :_  state
  [%give %fact ~[/srrstile] %json !>(make-tile-json)]~
::
++  peer-srrs-primary
  |=  wir=wire
  ^-  (quip card _state)
  ?.  =(our.bol src.bol)
    :_  state
    [%give %kick ~ ~]~
  [~ state]
::
++  our-beak  /(scot %p our.bol)/[q.byk.bol]/(scot %da now.bol)
::
++  wake
  |=  =wire
  ^-  (quip card _state)
  =^  cards  state
    ?+  wire
      [~ state]
        [%review-schedule @ @ @ ~]
      =/  item
        %+  biff
          (~(get by pubs) i.t.wire)
        |=(=stack (~(get by items.stack) i.t.t.wire))
      ?~  item
        ~&  srrs+"{(spud t.t.wire)} was scheduled for review, but no longer exists"
        [~ state]
      =/  raise  [%add-raised-item our.bol i.t.wire i.t.t.wire]
      =/  raise-card=card  [%give %fact ~[/srrs-primary] %srrs-primary-delta !>(raise)]
      :-  (flop (snoc make-tile-moves raise-card))
      %=  state
        review  (~(put in review.state) [our.bol i.t.wire i.t.t.wire])
      ==
    ==
  [cards state]
::
++  poke-noun
  |=  a=*
    ^-  (quip card _state)
    ?.  =(src.bol our.bol)
      [~ state]
    ?+  a
      [~ state]
        %print-json
      [~ state]
        %clear-state
      [~ *versioned-state]
        %clear-review
      [~ state(review review:*versioned-state)]
        %tile
      :_  state
      make-tile-moves
    ==
::
++  state-to-json
  |=  sat=_state
  ^-  json
  %-  pairs:enjs:format
  :~  :+  %pubs
        %o
      %+  roll  ~(tap by pubs.sat)
      |=  [[nom=@tas stack=stack] out=(map @t json)]
      %+  ~(put by out)
        nom
      (total-build-to-json stack)
  ::
      :+  %subs
        %o
      %-  ~(rep by subs.sat)
      |=  $:  [[who=@p nom=@tas] stack=stack]
              out=(map @t [%o (map @t json)])
          ==
      =/  shp=@t  (rsh 3 1 (scot %p who))
      ?:  (~(has by out) shp)
        %+  ~(put by out)
          shp
        :-  %o
        %+  ~(put by +:(~(got by out) shp))
          nom
        (total-build-to-json stack)
      %+  ~(put by out)
        shp
      :-  %o
      (my [nom (total-build-to-json stack)] ~)
  ::
      :+  %review
        %a
      %+  turn  ~(tap in review.sat)
      |=  [who=@p stack=@tas item=@tas]
      %-  pairs:enjs:format
      :~  who+s+(scot %p who)
          stack+s+stack
          item+s+item
      ==
  ==
::
++  make-tile-moves
  ^-  (list card)
  =/  del  [%update-review review.state]
  :~  [%give %fact ~[/srrs-primary] %srrs-primary-delta !>(del)]
      [%give %fact ~[/srrstile] %json !>(make-tile-json)]
  ==
::
++  make-tile-json
  ^-  json
  %-  pairs:enjs:format
  :~  review+(numb:enjs:format ~(wyt by review))
  ==
::
++  add-stack
  |=  [info=stack-info items=(map @tas item)]
  ^-  (quip card _state)
  =|  sta=stack
  =/  new-stack
  %=  sta
    stack  [%.y info]
    name  filename.info
    last-update  last-modified.info
    items  (~(uni by items) items.sta)
  ==
  =/  new-pubs  (~(put by pubs.state) filename.info new-stack)
  =/  del  [%add-stack our.bol filename.info new-stack]
    =/  mov=card  [%give %fact ~[/srrs-primary] %srrs-primary-delta !>(del)]
  [~[mov] state(pubs new-pubs)]
::
++  add-books
  |=  books=(map @tas notebook:publish)
  ^-  (quip card _state)
  %+  roll  ~(tap by books)
  |=  [book=[@tas notebook:publish] cad=(list card) sty=_state]
  ?:  (~(has by pubs.sty) -.book)
    [cad sty]
  =/  items
  (~(run by notes.book) |=(note=note:publish (item note (learned-status [.2.5 0 0]))))
  =/  act
  [%new-stack -.book title.book items %none read=*rule:clay write=*rule:clay]
  =/  mov=card
  [%pass /stacks %agent [our.bol %srrs] %poke %srrs-action !>(act)]
  [(snoc cad mov) sty]
::
++  update-learned-status
  |=  [stak=@tas item-name=@tas =recall-grade]
  ^-  (quip card _state)
  =/  old-stack=stack  (~(got by pubs.state) stak)
  =/  =item  (~(got by items.old-stack) item-name)
  =/  item-status=learned-status  learn.item
  =/  ease=@rs  (next-ease recall-grade item-status)
  =/  box=@  (next-box recall-grade item-status)
  =/  interval=@dr  (next-interval [ease box item-status])
  =/  new-item-status=learned-status  (learned-status [ease interval box])
  =/  new-item  item(learn new-item-status)
  =/  new-stack
    old-stack(items (~(put by items.old-stack) item-name new-item))
  =/  review-date=@da  (add now.bol interval)
  =/  schedule-card  [%pass /review-schedule/(scot %tas stak)/(scot %tas item-name)/(scot %da review-date) %arvo %b %wait review-date]~
  [schedule-card state(pubs (~(put by pubs) stak new-stack))]
::
++  next-ease
  |=  [=recall-grade =learned-status]
  ^-  @rs
  =/  ease-changes=(map ^recall-grade @rs)
  %-  malt
  ^-  (list [^recall-grade @rs])
  :~  [%again .-0.3]
      [%hard .-0.15]
      [%good .0]
      [%easy .0.15]
  ==

  =/  ease-min=@rs  .1.3
  =/  ease-max=@rs  .5.0
  ?:  (lth box.learned-status 2)
    ease.learned-status
  =/  chg  (~(got by ease-changes) recall-grade)
  =/  a  (add:rs ease.learned-status chg)
  ?:  (gte a ease-min)
    a
  ?:  (gte a ease-max)
    ease-max
  ease-min
::
++  next-box
  |=  [=recall-grade =learned-status]
  ^-  @
  ?:  ?&
        =(recall-grade %easy)
        =(box.learned-status 0)
      ==
    2
  ?:  =(recall-grade %again)  0
  (add box.learned-status 1)
::
++  next-interval
  |=  [next-ease=@rs next-box=@ =learned-status]
  ^-  @dr
  ::  ~15 min, 1 day, 6 days
  =/  fixed-intervals=(list @dr)  [~s5 ~m15 ~d1 ~d6 ~]
  ?:  (lth next-box (lent fixed-intervals))
    (snag next-box fixed-intervals)
  (interval-fuzz interval.learned-status next-ease)
::
++  interval-fuzz
  |=  [interval=@dr next-ease=@rs]
  ^-  @dr
  =/  random  ~(. og eny.bol)
  =/  interval-rs  (time-to-rs interval)
  =/  r=@rs  (add:rs `@rs`.0.9 (rad:random .1.1))
  =/  fuzzed  (mul:rs (mul:rs next-ease interval-rs) r)
  (rs-to-time fuzzed)
::
--

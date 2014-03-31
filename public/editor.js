// SET CROSS DOMAIN HOST
document.domain = document.location.host.split('.').splice(-2).join('.')

// UTILITIES

  function openTab( url ){  
     var $link = $('<a>', {
       "target" : "_blank",
       "href" : url
     });
    var element = $link.get(0);
    var evt = element.ownerDocument.createEvent('MouseEvents');    
    //https://developer.mozilla.org/en-US/docs/Web/API/event.initMouseEvent
    evt.initMouseEvent('click', true, true, element.ownerDocument.defaultView, 1, 0, 0, 0, 0, true, false, false, true, 0, null);
    if( document.createEventObject ) element.fireEvent('onclick', evt); else  element.dispatchEvent(evt);    
 }
  
  
  
//////////////////////////////////////

  function Editor(){
    this.initAce();    
    this._events = {always:[]};
    this._busy = false;
    this._latency = 400;
    this._marks = {};        
    this.loop();
   }
  
  // INIT ace
  Editor.prototype.initAce = function(){
    ace.require("ace/ext/language_tools");
    ace.require("ace/ext/emmet");

    this.ace = ace.edit( "editor" );    
    this.ace.setOption("enableEmmet", true);  
    this.ace.setShowPrintMargin( false );
    this.ace.setReadOnly( false );
    this.ace.getSession().setUseWrapMode(true);
    this.ace.getSession().setUseSoftTabs(true);       
    this.ace.setOptions({
      enableBasicAutocompletion: true, 
      enableEmmet: true,
      enableSnippets: true
    });
  }
  
  // SUPPORT log
  Editor.prototype.log = function( m, o ){
    if( console && console.log ){
      console.log( '%c' + m, 'color: blue; font-size: 18px;' );      
      if( o ) console.log( o );
    }
  }  
  
  Editor.prototype.debug = function( o ){
    if( console && console.log ){
      console.log( '%cDEBUG', 'background: #222; color: #bada55' );      
      if( o ) console.log( o );
    }  
  }
  
  // SUPPORT marks
  Editor.prototype.mark = function( m ){ this._marks[m] = true; }  
  Editor.prototype.unmark = function( m ){ this._marks[m] = false; }
  Editor.prototype.toggle = function( m ){ this._marks[m] = !this._marks[m]; }
  Editor.prototype.izz = function( m ){ return this._marks[m] || false; }  
  
  // SUPPORT phases
  Editor.prototype.phase = function( k ){ return this._phase_config[ k ]; }
  Editor.prototype.doing = function( p ){ return this._phase === p }
  Editor.prototype.enterPhase = function( p, c ){
    this._phase = p;
    this._phase_config = c || {};
    this.log( "PHASE " + p, c );
    this.cycle();
  }
  Editor.prototype.when = function( p, f, g ){
    if( g ){
      f2 = function( p2 ){
        if( this.izz( g ) ){ f.call( this, p2 ); }
      }
    } 
    if( this._events[p] ) this._events[p].push( g ? f2 : f );
    else this._events[p] = [g ? f2 : f];    
    
  }  
  Editor.prototype.whenever = function( f, g ){ this.when('always', f, g ); }  
  Editor.prototype.cycle = function(){

    if( this.izz('busy') ){ this.mark('cycle'); return; }
    this.mark('busy');        
    
    this._events.always.forEach( function( f ){
      f.call( this );      
    }, this);
    
    var pc = this._phase_config;
    var fx = this._events[ this._phase ];
    if( fx ){
      fx.forEach( function( f ){
        f.call( this, pc );
      }, this);
    }
    this.unmark('busy');
    if( this.izz('cycle') ){
       this.unmark('cycle');
       this.cycle(); 
    }
  }  

  // SUPPORT ajax
  Editor.prototype.ajax = function( b, m, u, p ){
    var self = this;
    self.enterPhase( b, { method: m, url: u } );
    $.ajax( u, {type: m} ).done( function( r ){      
      self.enterPhase( p, { method: m, url: u, reply: r } );
    });
  }    
  Editor.prototype.ajax_data = function( b, m, u, d, p ){
    var self = this;
    self.enterPhase( b, { method: m, url: u, data: d } );
    $.ajax( u, {type: m, data: d} ).done( function( r ){
      self.enterPhase( p, { reply: r, method: m, url: u } );
    });
  }    
  
  // SUPPORT mainloop
  Editor.prototype.setLatency = function( l ){ this._latency = l; }
  Editor.prototype.loop = function(){
    this.cycle(); 
    var self = this;
    setTimeout( function(){ self.loop(); }, this._latency )
  }    
  
  // PROPERTY skin
  Editor.prototype.getSkin = function(){ return this._skin }
  Editor.prototype.setSkin = function( s ){ 
    this._skin = s.replace("ace/theme/",""); 
    this.ace.setTheme( "ace/theme/" + this._skin );
  }  
  
  // PROPERTY code
  Editor.prototype.getCode = function(){ return this.ace.getSession().getValue(); }
  Editor.prototype.setCode = function( c ){ this.ace.getSession().setValue( c ); }  

  // PROPERTY lang
  Editor.prototype.getLang = function(){ return this._lang; }
  Editor.prototype.setLang = function( l ){
    this._lang = l.replace("ace/mode/", ""); 
    this.ace.getSession().setMode( "ace/mode/" + this._lang );
  }
  
  // PROPERTY font
  Editor.prototype.getFont = function(){ return this._font; }
  Editor.prototype.setFont = function( s, h ){ 
    this._font = { fontsize: s, lineheight: h }; 
     this.ace.setFontSize( s ); 
     $('#editor').css("line-height", h);
  }
  
  // PROPERTY title
  Editor.prototype.getTitle = function(){ return $('#title').val(); }
  Editor.prototype.setTitle = function( t ){ $('#title').val( t ); }
  
  // PROPERTY url
  Editor.prototype.getUrl = function(){ return this.url; }
  Editor.prototype.setUrl = function( u ){ this.url = u; }
  
  // PROPERTY noindex
  Editor.prototype.setNoindex = function( v ){ this._noindex = v; }
  Editor.prototype.getNoindex = function(){ return !!this._noindex; }
  
  // PROPERTY preview
  Editor.prototype.setPreview = function( v ){ $('#preview_url').val( v || null ); }
  Editor.prototype.getPreview = function(){ return $('#preview_url').val(); }
  
  // PROPERTY category
  Editor.prototype.setCategory = function( v ){ $('#category').val( v || null ); }
  Editor.prototype.getCategory = function(){ return $('#category').val(); }

  
  // RECORD
  Editor.prototype.getRecord = function(){
    return { title: this.getTitle(), langcode: this.getLang(), skin: this.getSkin(), lineheight: this._font.lineheight, fontsize: this._font.fontsize, code: this.getCode(), noindex: this.getNoindex(), preview_url: this.getPreview(), category: this.getCategory() }; 
  }  
  Editor.prototype.setRecord = function( p ){
    this.setTitle( p.title );
    this.setCode(  p.code  );
    this.setLang(  p.langcode  );    
    this.setSkin(  p.skin  );
    this.setNoindex( p.noindex );
    this.setPreview( p.preview_url );
    this.setFont(  p.fontsize, p.lineheight );
    this.setCategory( p.category );
  }
  
  // SUPPORT dirty-tracking
  Editor.prototype.izzClean = function(){
    return this.ace.getSession().getUndoManager().isClean()
  }
  Editor.prototype.markClean = function(){
    this.ace.getSession().getUndoManager().markClean();
  }
  
  // BEHAVIOR io
  Editor.prototype.enableIO = function(){
  
    // PROPERTY home
    this.setHome = function( h ){
      this._home = h;
      this.enterPhase('load', {url: h});    
    }
  
    this.mark('io');

    this.when('load', function( p ){       
       this.ajax( 'loading', 'GET', p.url, 'loaded' );     
    });
    
    this.when('create', function(){  
      var data = { fiddle: { code: "Your html file", lang:"html", fontsize:"16px", lineheight:"24px", skin:"chaos" } };
      this.ajax_data( 'loading', 'POST', '/fiddles.json', data, 'created' );  
    }); 
    
    this.when('created', function( p ){
      openTab( p.reply.url.replace('.json','/edit') );
      this.enterPhase('ready');
    });

    
    this.when('loaded', function( p ){
      this.setRecord( p.reply );
      this.setUrl( p.reply.url );
      this.enterPhase('ready');
    });
    
    this.when('save', function(){        
      this.ajax_data( 'saving', 'PUT', this.getUrl(), { fiddle: this.getRecord() }, 'saved' );  
    });
    
    this.when('saved', function(){
      this.enterPhase('ready');
    })
    
    var self = this;
    $(document).keydown( function(e){    
      
    
      // CTRL+S
      if( e.keyCode === 83 && e.ctrlKey === true && self.doing('ready') ){ 
        self.enterPhase('save');
        e.preventDefault();
      }
      
      // CTRL+INSERT
      if(  ( e.keyCode === 45 || e.keyCode == 96 ) && e.ctrlKey === true && self.doing('ready') ){ 
        self.enterPhase('create');
        e.preventDefault();
      }
      
      // ALT+HOME
      if( e.keyCode == 72 && e.ctrlKey === true && self.doing('ready') ){ 
        self.enterPhase('load', {url: self._home});    
        e.preventDefault();
      }     
      
    });    
        
  }
  
  // BEHAVIOR dirty-tracking
  Editor.prototype.enableDirtyTracking = function(){

    this.whenever( function(){    
      if( !this.izzClean() ){
        this._dirty = +(new Date);
        this.markClean();
        if( !this.izz('dirty') ){
          this.mark('dirty');        
          this.log('BUFFER IS DIRTY');
          $('#editor').addClass('dirty');
        }
      }
    });
    
    this.when('save', function(){
      this._lastSave = +(new Date);
      if( this.izz('dirty') ){
        this.unmark('dirty');
        $('#editor').removeClass('dirty');
        this.log('BUFFER IS CLEAN');
      }
    });

    var self = this;    
    $('#title').change( function(){ self.mark('dirty'); });
    $('#title').keydown( function(){ self.mark('dirty'); });
    
  }
  
  // BEHAVIOR autosave
  Editor.prototype.enableAutoSave = function(){  
    
    this.when('ready', function(){
      if( this.izz('dirty') && ( (+new Date) - this._dirty) > 1500 ){
        this.enterPhase('save');
      }
    }, 'autosave');
    
    var self = this;
    $(document).keydown( function( e ){
    
      // ALT+S
      if( self.izz('io') && e.keyCode === 83 && e.altKey === true && self.doing('ready') ){ 
        self.toggle('autosave');
        e.preventDefault();     
        if( self.doing('ready') ) self.enterPhase('save');
      }

    });
  
  } 

  // BEHAVIOR panel
  Editor.prototype.enablePanel = function(){
  
    this.setPanelSize = function( s ){ 
      $('#panel').css('width', s );
        $('#panel').css('left', '0%' );
        $('#panel').css('right', 'auto' );      
        $('#editor').css('left', this.getPanel() ? s : "0%");
        $('#editor').css('right', '0%');
        this.ace.resize(); 
    }    
    this.getPanelSize = function(){ return $('#panel').css( 'width' ) } 
    this.getPanel = function(){ return this._panel; }
    this.setPanel = function( p ){
      if( this._panel ) $( '#' + this._panel ).hide();
      var pp = $('#panel');
      if( p ){
        this._panel = p; 
        $( '#' + this._panel ).show();  
        if( !pp.hasClass('active') ) pp.addClass('active');      
      } else {
        this._panel = null;
        $('#editor').css('left', '0%');
        $('#editor').css('right', '0%');
        this.ace.resize();         
        if( pp.hasClass('active') ) pp.removeClass('active'); 
      }
    }        

    this._panel = null;    
    
    var self = this;
    $('#go_close').click( function(){
      self.setPanel(null);  
    });
    
    $(document).keydown( function( e ){
      if( e.keyCode == 27 && !e.altKey && !e.shiftKey && !e.ctrlKey ) self.setPanel( null );  
    });    
     
    
  }
  
  // BEHAVIOR help
  Editor.prototype.enableHelp = function(){
  
    var self = this;
    $(document).keydown( function(e){ // CTRL+P
      if( e.keyCode === 112 ){
        e.preventDefault();
        if( self.getPanel() == 'help' ){
          self.setPanel( null );
          self.setPanelSize('370px','left');                        
        } else {
          self.setPanel('help');
          self.setPanelSize('600px','left');    
        }
      }
    });
    
    $('#go_help').click( function(){
      self.setPanel('help');
      self.setPanelSize('600px','left');
    });

  
  }
  
  // BEHAVIOR props
  Editor.prototype.enableProps = function(){
  
    var self = this;
    $(document).keydown( function(e){ // CTRL+P
      if( e.keyCode === 190 && e.ctrlKey === true ){
        if( self.getPanel() == 'props' ){
          self.setPanel( null );          
          self.setPanelSize('370px', 'left');
        } else {
          self.setPanel('props');  
          self.setPanelSize('370px','left');              
        }
      }
    });    

    editor.whenever(function(){
      if( this.getLang() !== this._oldLang ){
        $('#langs div').removeClass('active');
        $('#lang_' + editor.getLang()).addClass('active');
        this._oldLang = this.getLang();
      }
    });   
    
    $('#go_props').click( function(){
      self.setPanel('props');
      self.setPanelSize('370px','left');
    });
  
  }
  
  // BEHAVIOR looks
  Editor.prototype.enableLooks = function(){
  
    var self = this;
    $(document).keydown( function(e){ // ALT+.
      if( e.keyCode === 190 && e.altKey === true ){
        if( self.getPanel() == 'looks' ){
          self.setPanel( null );          
          self.setPanelSize('370px', 'left');
        } else {
          self.setPanel('looks');  
          self.setPanelSize('370px','left');              
        }
      }
    });    
    
    editor.whenever(function(){
      if( this.getSkin() !== this._oldSkin ){
        $('#skins div').removeClass('active');
        $('#skin_' + editor.getSkin().replace('/','')).addClass('active');
        this._oldSkin = this.getSkin();
      }
    });
    
    $('#go_looks').click( function(){
      self.setPanel('looks');
      self.setPanelSize('370px','left');
    });

  
  }

  
  // BEHAVIOR preview
  Editor.prototype.enablePreview = function(){
  
    this.reloadPreview = function( f ){
      if( this.getUrl() ){
          this.log('RELOAD preview');
          $('#preview iframe').attr('src', this.getPreview());
      } 
    }    

    this.mark('preview-dirty');    

    this.when('loaded', function(){
       if( this.getPanel() === "preview" ){
         if( !this.izz('preview-sync') ) this.reloadPreview(); 
         else this.unmark('preview-sync');
        } else { 
          this.mark('preview-dirty'); 
        }
        $('#url').attr('href', (this.getUrl() || "#").replace('.json', ''));
        $('#url').html( (this.getUrl() || "(new)").replace(document.domain,'').replace('http://','').replace('.json','') );
    });
    
    this.when('saved', function(){
       if( this.getPanel() === "preview" ) this.reloadPreview(); else this.mark('preview-dirty');
    });
    
    this.whenever( function(){
      if( this.getPanel() === "preview" && this.izz('preview-dirty') ){
        this.unmark('preview-dirty');
        this.reloadPreview();
      }
      try{
        var u = $('iframe')[0].contentWindow.location.href;
        if(u !== "about:blank" && !$('#preview_url').is(":focus") ){
          self.setPreview( u );
        }
      }catch(err){}

    });
    
    var self = this;
    $(document).keydown( function(e){ // CTRL+ENTER
      if( e.keyCode === 13 && e.ctrlKey === true ){
        if( self.getPanel() == 'preview' ){
          self.setPanel( null );
          self.setPanelSize('370px', 'left');
        } else {        
          self.setPanel('preview');  
          self.setPanelSize('50%','left');              
        }
      }
    });
    
    $('#go_preview').click( function(){
      self.setPanel('preview');
      self.setPanelSize('50%','left');
    });

    
  }



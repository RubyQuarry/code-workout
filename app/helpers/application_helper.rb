module ApplicationHelper
  include ActionView::Helpers::JavaScriptHelper


  # -------------------------------------------------------------
  # For using nested layouts
  def inside_layout(layout = 'wrapper', &block)
    render :inline => capture_haml(&block), :layout => "layouts/#{layout}"
  end


  # -------------------------------------------------------------
  def controller_stylesheet_link_tag
    c = params[:controller]
    stylesheet_link_tag c if Rails.application.assets.find_asset("#{c}.css")
  end


  # -------------------------------------------------------------
  def controller_javascript_include_tag
    c = params[:controller]
    javascript_include_tag c if Rails.application.assets.find_asset("#{c}.js")
  end


  # -------------------------------------------------------------
  # Returns the correct twitter bootstrap class mapping for different
  # types of flash messages
  # 
  FLASH_CLASS = {
      success: 'alert-success',
      error:   'alert-danger',
      alert:   'alert-block',
      block:   'alert-block',
      notice:  'alert-info',
      info:    'alert-info'
  }
  def flash_class_for(level)
    FLASH_CLASS[level] || level.to_s
  end


  # -------------------------------------------------------------
  # Returns a FontAwesome icon name (without the prefix), if there
  # is one associated with the tag provided
  # 
  ICON_NAME = {
      'success' => 'ok-sign',
      'error'   => 'exclamation-sign',
      'danger'  => 'exclamation-sign',
      'alert'   => 'warning-sign',
      'block'   => 'warning-sign',
      'notice'  => 'info-sign',
      'info'    => 'info-sign',

      'show'    => 'zoom-in',
      'edit'    => 'edit',
      'delete'  => 'trash',
      'destroy' => 'trash',
      'back'    => 'reply',
      'new'     => 'plus',
      'add'     => 'plus',
      'ok'      => 'ok-sign',
      'cancel'  => 'remove-sign',
      'yes'     => 'thumbs-up',
      'no'      => 'thumbs-down',
      'like'    => 'thumbs-up',
      'unlike'  => 'thumbs-down'
  }
  def icon_name_for(tag)
    if !tag.nil?
      tag = tag.to_s
      if !tag.start_with?('glyphicon-', 'fa-')
        tag = tag.downcase.sub(/[^a-zA-Z0-9_-].*$/, '')
        name = ICON_NAME[tag] || tag
        if name.nil?
          name
        else
          'glyphicon-' + name
        end
      else
        tag
      end
    else
      tag
    end
  end


  # -------------------------------------------------------------
  def icon_tag_for(name, options = {})
    cls = icon_name_for(name) + ' icon-fixed-width'
    if cls.nil?
      ''
    else
      if cls.start_with?('glyphicon-')
        cls = 'glyphicon ' + cls
      elsif cls.start_with?('fa-')
        cls = 'fa ' + cls
      end
      if options[:class]
        cls = options[:class] + ' ' + cls
      else
        options[:class] = cls
      end
      content_tag :i, nil, class: cls
    end
  end


  # -------------------------------------------------------------
  def icon2x_tag_for(name, options = {})
    if options[:class]
      options[:class] += ' icon-2x'
    else
      options[:class] = 'icon-2x'
    end
    icon_tag_for(name, options)
  end


  # -------------------------------------------------------------
  def icon4x_tag_for(name, options = {})
    if options[:class]
      options[:class] += ' icon-4x'
    else
      options[:class] = 'icon-4x'
    end
    icon_tag_for(name, options)
  end


  # -------------------------------------------------------------
  # Creates a link styled as aBootstrap button.
  #
  def button_link(label, destination = '#', options = {})
    options[:class] = options[:class] || 'btn'
    if options[:btn]
      options[:class] = options[:class] + ' btn-' + options[:btn]
      options.delete(:btn)
    end
    if options[:size]
      options[:class] = options[:class] + ' btn-' + options[:size]
      options.delete(:size)
    end
    if options[:color]
      options[:class] = options[:class] + ' btn-' + options[:color]
      options.delete(:color)
    else
      options[:class] = options[:class] + ' btn-default'
    end
    text = label
    if options[:icon]
      text = icon_tag_for(options[:icon]) + ' ' + text
    end
    link_to text, destination, options       
  end


  # -------------------------------------------------------------
  # Creates a difficulty belt image.
  #
  BELT_COLOR = ["White", "Yellow", "Orange", "Green", "Blue", "Violet", "Brown", "Black"]
  def difficulty_image(val)
    levels = 8
    increments = 100.0/8
    if( val <= 0 )
      num = 1
    elsif( val > 100)
      num = 8
    else
      num = val/(increments).round
    end
    if( num == 0 )
      color = "White"
    else
      color = BELT_COLOR[num]
    end
    image_tag("belt"+num.to_s+".png", alt: color.to_s+" Belt ("+val.to_s+")")
  end
end
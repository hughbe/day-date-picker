Pod::Spec.new do |s|
  s.name             = 'DayDatePicker'
  s.version          = '1.0'
  s.summary          = 'A custom and customizable UIDatePicker which displays the day of the week alongside the day column'

  s.description      = <<-DESC
A custom and customizable UIDatePicker which displays the day of the week alongside the day column. You can customize the appearance and behaviour of the control.
                       DESC

  s.homepage         = 'https://github.com/hughbe/DayDatePicker'
  s.screenshots     = 'https://raw.githubusercontent.com/hughbe/day-date-picker/master/resources/screenshots/1.png', 'https://raw.githubusercontent.com/hughbe/day-date-picker/master/resources/screenshots/2.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hughbe' => 'hughbellars@gmail.com' }
  s.source           = { :git => 'https://github.com/hughbe/day-date-picker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'

  s.source_files = 'DayDatePicker/Classes/**/*'
  s.frameworks = 'UIKit'
end

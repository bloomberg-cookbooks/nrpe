#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

class FalseClass; def to_i; 0; end end
class TrueClass; def to_i; 1; end end

module NrpeCookbook
  module Resource
    def default_nrpe_plugins
      return '/usr/lib/nagios/plugins' if platform_family? 'debian'
      '/usr/lib64/nagios/plugins'
    end
  end
end

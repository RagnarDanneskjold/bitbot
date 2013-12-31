module BitBot
  module Utility
    private
    def rekey(hash, map)
      hash = hash.dup
      map.each do |ok, nk|
        ok, nk = ok.to_s, nk.to_s

        ov = hash.delete(ok)
        hash.store nk, ov unless nk.empty?
      end
      hash
    end
  end
end

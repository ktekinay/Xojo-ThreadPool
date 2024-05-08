#tag Class
Protected Class ThreeN1ThreadPool
Inherits ThreadPool
	#tag Event , Description = 496D706C656D656E7420746F2068616E646C652070726F63657373696E67206F66206F6E65206974656D206F6620646174612E
		Function Process(data As Variant) As Variant
		  var value as integer = data.IntegerValue
		  
		  while value <> 1
		    if ( value mod 2 ) = 0 then
		      value = value \ 2
		    else
		      value = 3 * value + 1
		    end if
		  wend
		  
		  System.DebugLog "Processed " + data.StringValue
		  return value
		  
		End Function
	#tag EndEvent


End Class
#tag EndClass

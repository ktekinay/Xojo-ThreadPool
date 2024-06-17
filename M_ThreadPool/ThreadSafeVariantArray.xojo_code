#tag Class
Class ThreadSafeVariantArray
Implements Iterable
	#tag Method, Flags = &h0
		Sub Add(item As Variant)
		  Lock
		  
		  self.Data.Add item
		  
		  Unlock
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddAt(index As Integer, item As Variant)
		  Lock
		  
		  Data.AddAt( index, item )
		  
		  Unlock
		  
		  Exception err as RuntimeException
		    try
		      Unlock
		    end try
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Locker = new CriticalSection
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IndexOf(item As Variant) As Integer
		  Lock
		  
		  var result as integer = Data.IndexOf( item )
		  
		  Unlock
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Iterator() As Iterator
		  Lock
		  
		  var newArr() as variant
		  newArr.ResizeTo Data.LastIndex
		  
		  for i as integer = 0 to Data.LastIndex
		    newArr( i ) = Data( i )
		  next
		  
		  Unlock
		  
		  return new M_ThreadPool.ThreadSafeVariantArrayIterator( newArr )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Lock()
		  Locker.Enter
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Operator_Convert() As Variant()
		  Lock
		  
		  var result() as variant
		  result.ResizeTo Data.LastIndex
		  
		  for i as integer = 0 to Data.LastIndex
		    result( i ) = Data( i )
		  next
		  
		  Unlock
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub Operator_Convert(source() As Variant)
		  Constructor
		  
		  Data.ResizeTo source.LastIndex
		  
		  for i as integer = 0 to source.LastIndex
		    Data( i ) = source( i )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Operator_Subscript(index As Integer) As Variant
		  Lock
		  
		  var result as variant = self.Data( index )
		  
		  Unlock
		  
		  return result
		  
		  Exception err as RuntimeException
		    try
		      Unlock
		    end try
		    
		    raise err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub Operator_Subscript(index As Integer, Assigns item As Variant)
		  Lock
		  
		  self.Data( index ) = item
		  
		  Unlock
		  
		  Exception err as RuntimeException
		    try
		      Unlock
		    end try
		    
		    raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pop() As Variant
		  Lock
		  
		  var result as variant = self.Data.Pop
		  
		  Unlock
		  
		  return result
		  
		  Exception err as RuntimeException
		    try
		      Unlock
		    end try
		    
		    raise err
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  Lock
		  
		  Data.RemoveAll
		  
		  Unlock
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(index As Integer)
		  Lock
		  
		  Data.RemoveAt( index )
		  
		  Unlock
		  
		  Exception err as RuntimeException
		    try
		      Unlock
		    end try
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResizeTo(newSize As Integer)
		  if newSize < -1 then
		    raise new OutOfBoundsException
		  end if
		  
		  Lock
		  
		  Data.ResizeTo newSize
		  
		  Unlock
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shuffle()
		  Lock
		  
		  Data.Shuffle
		  
		  Unlock
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sort(sorter As SortDelegate)
		  Lock
		  
		  Data.Sort sorter
		  
		  Unlock
		  
		  Exception err As RuntimeException
		    try
		      Unlock
		    end try
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h21
		Private Delegate Function SortDelegate(item1 As Variant, item2 As Variant) As Integer
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h1
		Protected Sub Unlock()
		  Locker.Leave
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  var count as integer
			  
			  Lock
			  
			  count = self.Data.Count
			  
			  Unlock
			  
			  return count
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected Data() As Variant
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Lock
			  
			  var lastIndex as integer = self.Data.LastIndex
			  
			  Unlock
			  
			  return lastIndex
			End Get
		#tag EndGetter
		LastIndex As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Locker As CriticalSection
	#tag EndProperty


	#tag Constant, Name = FirstIndex, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

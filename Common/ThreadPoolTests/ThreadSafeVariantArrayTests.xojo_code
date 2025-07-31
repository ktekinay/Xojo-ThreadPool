#tag Class
Protected Class ThreadSafeVariantArrayTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AddAtTest()
		  var arr as new ThreadSafeVariantArray
		  
		  arr.AddAt 0, 1
		  arr.AddAt 0, 2
		  
		  Assert.AreEqual 2, arr.Count
		  Assert.AreEqual 1, arr.LastIndex
		  Assert.AreEqual 2, arr( 0 ).IntegerValue
		  Assert.AreEqual 1, arr( 1 ).IntegerValue
		  
		  #pragma BreakOnExceptions false
		  try
		    arr.AddAt 100, 2
		    Assert.Fail "Adding at a bad index"
		  catch err as OutOfBoundsException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  AssertUnlocked arr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddTest()
		  var arr as new ThreadSafeVariantArray
		  
		  arr.Add 1
		  
		  Assert.AreEqual 1, arr.Count
		  Assert.AreEqual 0, arr.LastIndex
		  Assert.AreEqual 1, arr( 0 ).IntegerValue
		  
		  AssertUnlocked arr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AssertUnlocked(arr As ThreadSafeVariantArray)
		  var spy as new ObjectSpy( arr )
		  var cs as CriticalSection = spy.Locker
		  
		  if cs.TryEnter then
		    cs.Leave
		    Assert.Pass
		  else
		    Assert.Fail "Was locked"
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConvertTest()
		  var source() as variant
		  
		  source.Add 0
		  source.Add 1
		  source.Add 2
		  
		  var arr as ThreadSafeVariantArray = source
		  
		  Assert.AreEqual 3, arr.Count
		  
		  for i as integer = 0 to arr.LastIndex
		    Assert.AreEqual i, arr( i ).IntegerValue
		  next
		  
		  source.RemoveAll
		  
		  Assert.AreEqual 3, arr.Count
		  
		  AssertUnlocked arr
		  
		  source = arr
		  var sourceCount as integer = source.Count
		  
		  Assert.AreEqual arr.Count, sourceCount
		  
		  for i as integer = 0 to arr.LastIndex
		    Assert.AreEqual arr( i ).IntegerValue, source( i ).IntegerValue
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CountAndLastIndexTest()
		  var arr as new ThreadSafeVariantArray
		  
		  Assert.AreEqual 0, arr.Count
		  Assert.AreEqual -1, arr.LastIndex
		  
		  for i as integer = 1 to 10
		    arr.Add i
		    Assert.AreEqual i, arr.Count
		    Assert.AreEqual i - 1, arr.LastIndex
		  next
		  
		  AssertUnlocked arr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IndexOfTest()
		  var arr as new ThreadSafeVariantArray
		  
		  for i as integer = 0 to 10
		    arr.Add i
		  next
		  
		  for i as integer = 10 downto 0
		    Assert.AreEqual i, arr.IndexOf( i )
		  next
		  
		  AssertUnlocked arr
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IteratorTest()
		  var arr as new ThreadSafeVariantArray
		  
		  for i as integer = 10 downto 0
		    arr.Add i
		  next
		  
		  var lastIndex as integer = arr.LastIndex
		  
		  for each i as integer in arr
		    Assert.AreEqual lastIndex, i
		    lastIndex = lastIndex - 1
		  next
		  
		  Assert.AreEqual -1, lastIndex
		  
		  AssertUnlocked arr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopTest()
		  var arr as new ThreadSafeVariantArray
		  
		  for i as integer = 1 to 10
		    arr.Add i
		  next
		  
		  for i as integer = 10 downto 1
		    Assert.AreEqual i, arr.Pop.IntegerValue
		  next
		  
		  Assert.AreEqual 0, arr.Count
		  
		  #pragma BreakOnExceptions false
		  try
		    call arr.Pop
		    Assert.Fail "Popped an empty array"
		  catch err as OutOfBoundsException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  AssertUnlocked arr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAllTest()
		  var arr as new ThreadSafeVariantArray
		  
		  for i as integer = 1 to 10
		    arr.Add i
		    Assert.AreEqual i, arr.Count
		    Assert.AreEqual i - 1, arr.LastIndex
		  next
		  
		  arr.RemoveAll
		  Assert.AreEqual 0, arr.Count
		  
		  AssertUnlocked arr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAtTest()
		  var arr as new ThreadSafeVariantArray
		  
		  arr.Add 1
		  arr.RemoveAt 0
		  
		  Assert.AreEqual 0, arr.Count
		  Assert.AreEqual -1, arr.LastIndex
		  
		  #pragma BreakOnExceptions false
		  try
		    arr.RemoveAt 0
		    Assert.Fail "Removing an index that doesn't exist"
		  catch err as OutOfBoundsException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  AssertUnlocked arr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResizeToTest()
		  var arr as new ThreadSafeVariantArray
		  
		  arr.ResizeTo 10
		  AssertUnlocked arr
		  
		  Assert.AreEqual 10, arr.LastIndex
		  
		  arr.ResizeTo 0
		  AssertUnlocked arr
		  
		  Assert.AreEqual 0, arr.LastIndex
		  
		  arr.ResizeTo -1
		  AssertUnlocked arr
		  
		  Assert.AreEqual 0, arr.Count
		  
		  #pragma BreakOnExceptions false
		  try
		    arr.ResizeTo -2
		    Assert.Fail "ResizeTo invalid index"
		  catch err as OutOfBoundsException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  AssertUnlocked arr
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShuffleTest()
		  var arr as new ThreadSafeVariantArray
		  
		  for i as integer = 1 to 100
		    arr.Add i
		  next
		  
		  arr.Shuffle
		  
		  AssertUnlocked arr
		  
		  for i as integer = 1 to arr.LastIndex
		    if arr( i - 1 ) > arr( i ) then
		      AssertUnlocked arr
		      return
		    end if
		  next
		  
		  Assert.Fail "Not shuffled"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Sorter(i1 As Variant, i2 As Variant) As Integer
		  return i1.IntegerValue - i2.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SortTest()
		  var arr as new ThreadSafeVariantArray
		  
		  arr.Add 10
		  arr.Add 1
		  arr.Add 31
		  arr.Add 21
		  
		  arr.Sort AddressOf sorter
		  
		  for i as integer = 1 to arr.LastIndex
		    Assert.IsTrue arr( i - 1 ) < arr( i )
		  next
		  
		  AssertUnlocked arr
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
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
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
	#tag EndViewBehavior
End Class
#tag EndClass

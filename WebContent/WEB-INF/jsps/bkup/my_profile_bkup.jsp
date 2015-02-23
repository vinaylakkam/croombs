<div id="div_preferences" style="disply:none">					
							<h4> 
								<a href="#" id="a_edit_preferences" onclick="javascript:editDetails('preferences')" style="float:right">
									<span id="span_edit_preferences">edit</span>
								</a> Preferences 
							</h4>
	
							<div id="div_preferences_view"> 
								<table class="tableView"> 
									<tr>
										<td class="label1"> Default room on 'Bookings' page:</td>
										<td id="view_def_roomid">
											<c:forEach var="room" items="${roomList}">
												<c:if test="${room.roomId eq userProfile.prefRoomId}">
													${room.name}
												</c:if>
											</c:forEach>						
										</td>
									</tr>								
									<tr>
										<td class="label1"> Number of days on 'Bookings' page:</td>
										<td  id="view_def_ndays">
											<c:forEach var="i" begin="1" end="30" step="1">
												<c:if test="${i eq userProfile.prefBookDays}">
													${i}
												</c:if>
											</c:forEach>
										</td>
									</tr>
								</table>
							</div>  
							<div id="div_preferences_edit"  style="display:none"> 
								<table class="tableEdit"> 
									<tr>
										<td class="label1"> 
											<label for="Opt_DefRoom">Default room on 'Bookings' page:</label>
										</td>
										<td>
											<!--  ROOMS Option box -->
											<select name="Opt_DefRoom" id="Opt_DefRoom">
												<c:forEach var="room" items="${roomList}">
													<option value="${room.roomId}" data="${room.name}">${room.name}</option>
												</c:forEach>
											</select>									
										</td>
									</tr>
									<tr>
										<td class="label1"> 
											<label for="Opt_DefDays">Number of days on 'Bookings' page:</label>
										</td>
										<td>
											<select name="Opt_DefDays" id="Opt_DefDays">
												<option value="0">Please select...</option>
												<c:forEach var="i" begin="1" end="30" step="1">
													<option value="${i}">${i}</option>
												</c:forEach>
											</select>
										</td>
									</tr>								
	 								<tr style="padding-top:10px">
										<td colspan="2">
											<input type="button" value="Save" onclick="javascript:saveDetails('preferences')"/> or
											<a href="#" onclick="cancelEdit('preferences')"> Cancel</a>
										</td>
									</tr>
								</table>
							</div>
							<span id="span_preferences_save_status" style="padding-top:20px"></span>
						</div>
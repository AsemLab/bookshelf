<%@ page language="java" contentType="text/html; charset=windows-1256"
	pageEncoding="windows-1256"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
<head>
<meta charset="windows-1256">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We"
	crossorigin="anonymous">

<style>
.w-50, .w-25, .fs-4 {
	margin-left: 0px;
	margin-top: 4px;
}

.col-6 {
	margin-bottom: 16px;
}

.btn-check, .btn {
	margin-left: 8px;
	margin-right: 8px;
}
</style>

<script type="text/javascript">
	var filter = "bookName";
	function search() {
		var text = document.getElementById("searchText").value;
		window.location.href = "http://localhost:8080/Bookshelf/owner/history/search?library="
				+ ${library_id}	+"&name=" + text + "&filter=" + filter;

	}

	function selectFilter(id) {
		filter = id;
	}
	
	function sort(){
		var sortBy = document.querySelector('input[name="sortOptions"]:checked').value;
		var descending = 1;
		if(document.getElementById("descendingBox").checked)
			descending = -1
			
		window.location.href = "http://localhost:8080/Bookshelf/owner/history/sort?library="+ ${library_id}	+"&sortby="
				+sortBy+"&asc="+descending;
	}
	
	function start(a,b){
		if(b != null ){
			if(b == -1)
				document.getElementById("descendingBox").checked = true;
			else
				document.getElementById("descendingBox").checked = false;
		}else
			document.getElementById("descendingBox").checked = true;

		if(a != null)
			switch(a){
			case "bookName" : document.getElementById("sBookName").checked = true; break;
			case "customerName" : document.getElementById("sCustomerName").checked = true; break;
			default : document.getElementById("sDate").checked = true; break;
			}
		else
			document.getElementById("sDate").checked = true;
	}
</script>



<title>${library_name }-history</title>
</head>
<body onload="start('${param.sortby  }',${param.asc} )">

	<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>


	<div class="container">
		<div class="row ">
			<div class="col-4" style="margin-top: 16px; margin-bottom: 16px">
				<a style="text-decoration: none; color: blue"
					href="http://localhost:8080/Bookshelf/book/library?id=${library_id}"
					class="display-6">${library_name}</a>
			</div>
			<div class="col-8">
				<div class="input-group mb-3 w-75 p-3">

					<input id="searchText" type="text" class="form-control"
						placeholder="Search">
					<button id="searchBtn" type="button" class="btn btn-primary"
						onclick="search()">Search</button>
					<input type="radio" class="btn-check" name="searchFilter"
						id="bookName" autocomplete="off"
						onclick="selectFilter('bookName') " checked> <label
						class="btn btn-outline-secondary" for="bookName">Book name</label>
					<input type="radio" class="btn-check" name="searchFilter"
						id="customerName" autocomplete="off"
						onclick="selectFilter('customerName')"> <label
						class="btn btn-outline-secondary" for="customerName">Customer
						name</label>
				</div>
			</div>
		</div>
	</div>

	<div class="container">
		<div class="row ">
			<div class="col-8">
				<strong>Sort by: </strong>
				<div class="form-check form-check-inline">
					<input class="form-check-input" type="radio" name="sortOptions"
						id="sBookName" value="bookName" onclick="sort()"> <label
						class="form-check-label" for="sBookName">book name</label>
				</div>
				<div class="form-check form-check-inline">
					<input class="form-check-input" type="radio" name="sortOptions"
						id="sCustomerName" value="customerName" onclick="sort()">
					<label class="form-check-label" for="sCustomerName">customer
						name</label>
				</div>
				<div class="form-check form-check-inline">
					<input class="form-check-input" type="radio" name="sortOptions"
						id="sDate" value="date" onclick="sort()"> <label
						class="form-check-label" for="sDate">date</label>
				</div>
				<span class="form-check form-check-inline "> <input
					class="form-check-input" type="checkbox" id="descendingBox"
					autocomplete="off" onclick="sort()"> <label
					class="form-check-label" for="flexSwitchCheckDefault">Descending</label>
				</span>
			</div>
		</div>
	</div>
	<br>


	<div class="container">
		<div class="row ">

			<div class="col-12 list-group">
				<c:if test="${empty(borrow)}">
					<h4 style="margin: 32px">The borrowing history is empty.</h4>
				</c:if>
				<c:forEach items='${borrow}' var='i'>
					<a href="#" data-bs-toggle="modal"
						data-bs-target="#myModal${i.getCustomer().getPerson_id() }"
						class="list-group-item list-group-item-action" aria-current="true">
						<div class="d-flex w-100 justify-content-between">
							<h5 class="mb-1">${i.getBook().getBook().getName() }</h5>
							<small>${i.getAcccept() }</small>
						</div>
						<div class="d-flex w-100 justify-content-between">
							<p class="mb-1">${i.getCustomer().getName() }</p>
							<c:choose>
								<c:when test="${i.getStatus() == 'accepted' }">
									<span class="badge bg-success rounded-pill">accepted</span>
								</c:when>
								<c:when test="${i.getStatus() == 'rejected' }">
									<span class="badge bg-danger rounded-pill">rejected</span>
								</c:when>
								<c:otherwise>
									<span class="badge bg-primary rounded-pill">${i.getStatus()}</span>
								</c:otherwise>

							</c:choose>

						</div>
					</a>
					<div class="modal fade"
						id="myModal${i.getCustomer().getPerson_id() }"
						aria-labelledby="exampleModalLabel" aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="myModal">Customer information</h5>
									<button type="button" class="btn-close" data-bs-dismiss="modal"
										aria-label="Close"></button>
								</div>
								<div class="modal-body">
									<p>
										<strong>Name: </strong>${i.getCustomer().getName()}</p>
									<p>
										<strong>Phone number: </strong>${i.getCustomer().getPhone_number()}</p>
									<p>
										<strong>Email: </strong>${i.getCustomer().getEmail()}</p>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-bs-dismiss="modal">Close</button>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>

			<div class="col-12 list-group">
				<c:if test="${empty(buy)}">
					<h4 style="margin: 32px">The buying history is empty.</h4>
				</c:if>
				<c:forEach items="${buy }" var="i">
					<a href="#" data-bs-toggle="modal"
						data-bs-target="#myModal${i.getPerson().getPerson_id() }"
						class="list-group-item list-group-item-action" aria-current="true">
						<div class="d-flex w-100 justify-content-between">
							<h5 class="mb-1">${i.getBooksLibrary().getBook().getName() }</h5>
							<small>${i.getBuy_date() }</small>
						</div>
						<div class="d-flex w-100 justify-content-between">
							<p class="mb-1">${i.getPerson().getName() }</p>
						</div>

					</a>
					<div class="modal fade"
						id="myModal${i.getPerson().getPerson_id() }"
						aria-labelledby="exampleModalLabel" aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="myModal">Customer information</h5>
									<button type="button" class="btn-close" data-bs-dismiss="modal"
										aria-label="Close"></button>
								</div>
								<div class="modal-body">
									<p>
										<strong>Name: </strong>${i.getPerson().getName()}</p>
									<p>
										<strong>Phone number: </strong>${i.getPerson().getPhone_number()}</p>
									<p>
										<strong>Email: </strong>${i.getPerson().getEmail()}</p>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-bs-dismiss="modal">Close</button>
								</div>
							</div>
						</div>
					</div>

				</c:forEach>
			</div>
		</div>
	</div>
	<br>
	<br>

	<!-- Bootstrap scripts   ************************************************* -->
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj"
		crossorigin="anonymous"></script>

	<jsp:include page="/WEB-INF/tags/footerTag.jsp"></jsp:include>
</body>
</html>
package jo.secondstep.bookshelf.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jo.secondstep.bookshelf.entities.BorrowOperations;
import jo.secondstep.bookshelf.entities.BuyOperations;
import jo.secondstep.bookshelf.repositories.BorrowOperationRepository;
import jo.secondstep.bookshelf.repositories.BuyOperationsRepository;
import jo.secondstep.bookshelf.repositories.LibraryRepository;

@Controller
@RequestMapping(value = "owner")
public class OwnerController {

	@Autowired
	private BuyOperationsRepository buyOperationsRepository;

	@Autowired
	private BorrowOperationRepository borrowOperationRepository;
	@Autowired
	private LibraryRepository libraryRepository;
	private String libraryName;
	private List<BorrowOperations> borrows;
	private List<BuyOperations> buys;

	@RequestMapping(value = "/history")
	public String getAllBuyOperations(ModelMap map, @RequestParam(defaultValue = "1", name = "library") Integer id) {

		buys = buyOperationsRepository.getOperationsByLibrary(id);
		borrows = borrowOperationRepository.getOperationsByLibrary(id);

		map.addAttribute("library_id", id);
		map.addAttribute("buy", buys);
		map.addAttribute("borrow", borrows);
		libraryName = libraryRepository.findById(id).get().getLibrary_name();
		map.addAttribute("library_name", libraryName);

		return "/owner/history";
	}

	@GetMapping(path = "/history/search")
	public String search(@RequestParam(name = "library") Integer id, @RequestParam(name = "name") String name,
			@RequestParam(name = "filter") String filter, ModelMap map) {

		buys = buyOperationsRepository.getOperationsByLibrary(id);
		borrows = borrowOperationRepository.getOperationsByLibrary(id);
		
		Object[] borrowResult = null;
		Object[] buyResult = null;

		switch (filter) {
		case "bookName":
			borrowResult = borrows.stream()
					.filter(b -> b.getBook().getBook().getName().toLowerCase().contains(name.toLowerCase())).toArray();
			buyResult = buys.stream()
					.filter(b -> b.getBooksLibrary().getBook().getName().toLowerCase().contains(name.toLowerCase()))
					.toArray();
			break;
		case "customerName":
			borrowResult = borrows.stream()
					.filter(b -> b.getCustomer().getName().toLowerCase().contains(name.toLowerCase())).toArray();
			buyResult = buys.stream().filter(b -> b.getPerson().getName().toLowerCase().contains(name.toLowerCase()))
					.toArray();
			break;
		}
		
		map.addAttribute("borrow", borrowResult);
		map.addAttribute("buy", buyResult);

		map.addAttribute("library_id", id);
		libraryName = libraryRepository.findById(id).get().getLibrary_name();
		map.addAttribute("library_name", libraryName);

		return "/owner/history";

	}

	@GetMapping(path = "/history/sort")
	public String sort(@RequestParam(name = "library") Integer id, @RequestParam(name = "sortby") String sortMethod,
			@RequestParam(name = "asc") Integer ascending, ModelMap map) {

		Object[] borrowResult = null;
		Object[] buyResult = null;

		switch (sortMethod) {
		case "bookName":
			borrowResult = borrows.stream()
					.sorted((a, b) -> a.getBook().getBook().getName().compareTo(b.getBook().getBook().getName()) * ascending)
					.toArray();
			buyResult = buys.stream().sorted(
					(a, b) -> a.getBooksLibrary().getBook().getName().compareTo(b.getBooksLibrary().getBook().getName())
							* ascending)
					.toArray();
			break;
		case "customerName":
			borrowResult = borrows.stream()
					.sorted((a, b) -> a.getCustomer().getName().compareTo(b.getCustomer().getName()) * ascending).toArray();
			buyResult = buys.stream()
					.sorted((a, b) -> a.getPerson().getName().compareTo(b.getPerson().getName()) * ascending).toArray();
			break;
		case "date":
			borrowResult = borrows.stream()
					.sorted((a, b) -> a.getAcccept().compareTo(b.getAcccept()) * ascending).toArray();
			buyResult = buys.stream()
					.sorted((a, b) -> a.getBuy_date().compareTo(b.getBuy_date()) * ascending).toArray();
			break;
		}

		map.addAttribute("borrow", borrowResult);
		map.addAttribute("buy", buyResult);

		map.addAttribute("library_id", id);
		map.addAttribute("library_name", libraryName);

		return "/owner/history";
	}

}
